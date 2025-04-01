using DataFrames, ScatteredInterpolation, Impute, Interpolations

function makeinterpolant(df::DataFrame, method::String)
    # Extract unique values for the grid
    k_cap_vals = sort(unique(df.k_cap))
    k_del_vals = sort(unique(df.k_del))
    r_cap_vals = sort(unique(df.r_cap))

    kcap_range= (minimum(k_cap_vals), maximum(k_cap_vals))
    kdel_range= (minimum(k_del_vals), maximum(k_del_vals))
    rcap_range = (minimum(r_cap_vals), maximum(r_cap_vals))

    if method == "grid"
        # Create a full grid
        grid_points = [(kc, kd, rc) for kc in k_cap_vals, kd in k_del_vals, rc in r_cap_vals]

        # Map existing values into a dictionary
        data_dict = Dict(zip(zip(df.k_cap, df.k_del, df.r_cap), df.kpoly))

        # Fill missing values with NaNs (detect missing values)
        #values = [get(data_dict, (kc, kd, rc), NaN) for (kc, kd, rc) in grid_points]

        # Replace missing values with the average of the nearest points
        values = [get(data_dict, (kc, kd, rc), get_nearest_avg(data_dict, kc, kd, rc, grid_points)) for (kc, kd, rc) in grid_points]

        # Reshape into a 3D array matching grid structure
        values_array = reshape(values, length(k_cap_vals), length(k_del_vals), length(r_cap_vals))

        # **Impute missing values using interpolation**
        # Use interpolate function to fill missing data with interpolation
        values_array = Impute.interpolate(values_array)

        # Create a grid of the (k_cap_vals, k_del_vals, r_cap_vals)
        grid = (k_cap_vals, k_del_vals, r_cap_vals)

        # Interpolate using Interpolations.jl
        interp = Interpolations.interpolate(grid, values_array, Gridded(Linear()))

        # Return the interpolator
        return interp, kcap_range, kdel_range, rcap_range

    elseif method == "scattered"
        # Use ScatteredInterpolation.jl for scattered data interpolation

        # Extract data as vectors
        x = df.k_cap
        y = df.k_del
        z = df.r_cap
        values = df.kpoly

        # Combine x, y, and z into a single matrix (each row is a point)
        points = hcat(x, y, z)'

        # Create a 3D scattered interpolator using Radial Basis Functions (RBF)
        interp = ScatteredInterpolation.interpolate(InverseMultiquadratic(), points, values)
        
        # Return a function that directly evaluates the interpolation
        return (k_cap, k_del, r_cap) -> ScatteredInterpolation.evaluate(interp, [k_cap, k_del, r_cap]), kcap_range, kdel_range, rcap_range

    else
        error("Invalid method: Choose either \"grid\" or \"scattered\"")
    end
end

function get_nearest_avg(data_dict, kc, kd, rc, grid_points)
    # Find the nearest points to (kc, kd, rc) in grid_points
    distances = [(abs(kc - kc_n) + abs(kd - kd_n) + abs(rc - rc_n), (kc_n, kd_n, rc_n)) for (kc_n, kd_n, rc_n) in grid_points if (kc_n, kd_n, rc_n) != (kc, kd, rc)]
    
    # Sort by distance and select the nearest points
    sorted_distances = sort(distances, by = x -> x[1])
    nearest_points = [get(data_dict, point, NaN) for (_, point) in sorted_distances[1:3]]  # Adjust to how many nearest points you want to use
    
    # Calculate the sum and count of valid (non-NaN) values
    valid_points = filter(!isnan, nearest_points)
    total = sum(valid_points)
    count = length(valid_points)
    
    # Calculate the average (handle the case where there are no valid points)
    nearest_avg = count > 0 ? total / count : NaN
    
    return nearest_avg
end
