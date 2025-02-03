using Statistics, Printf, JLD2

function getOutputControl(input_fname::String; saveTF::Bool = true, 
    input_file_path::String = "", 
    output_file_path::String = "$(input_file_path)", 
    output_fname::String = "$(input_fname)_outputstruct.jld2")
    """
    Reads a vertical ASCII file of output values generated by `outputControl.c` 
    and converts it to a Julia dictionary-like structure.

    Arguments:
        input_fname::String: The name of the .txt output file to parse.
        saveTF::Bool: Whether to save the output structure to a file (default: false).
        input_file_path::String: Path to the input file if not in the current directory (default: "").
        output_file_path::String: Path to save the output file (default: "").
        output_fname::String: Name of the output file (default: "<input_fname>.mat").
        tempdir::String: Path to store temporary files (default: "/tmp/").

    Returns:
        A dictionary-like structure containing parsed data.
    """

    full_input_file = joinpath(input_file_path, input_fname)
    full_temp_file = joinpath(input_file_path, input_fname)
    file_path_sorted_nosquare = "$full_temp_file.sorted.nosquare"

    if isfile(joinpath(output_file_path, output_fname))
        return load(joinpath(output_file_path, output_fname),"output_struct")
    end

    if !isfile(file_path_sorted_nosquare)
        # Create temp files and process with shell commands
        # run(`tail -r $full_input_file | awk '!flag; /nt /{flag = 1};' | tail -r | sort > "$full_temp_file.sorted"`)
        sorted_file = "$full_temp_file.sorted"
        
        open(sorted_file, "w") do io
            # Read the input file in reverse order
            lines = readlines(full_input_file)
            reversed_lines = reverse(lines)
        
            # Apply the AWK-like filter to keep only lines before the first match of "nt "
            result = []
            flag = false
            for line in reversed_lines
                if occursin("nt ", line)
                    flag = true
                end
                if !flag
                    push!(result, line)
                end
            end
        
            # Reverse the result again and sort it
            final_result = sort(reverse(result))
        
            # Write the sorted result to the output file
            write(io, join(final_result, "\n"))
        end
        
    
        # run(`sed 's/\[[^]]*\]//g' $full_temp_file.sorted > "$full_temp_file.sorted.nosquare"`)
        cmd = pipeline(`sed 's/\[[^]]*\]//g' $full_temp_file.sorted`; 
                    stdout="$full_temp_file.sorted.nosquare")
        run(cmd)

        # Clean up temp files
        rm("$full_temp_file.sorted", force=true)
    end

    MAXDIM = 1000  # Maximum assumed dimension for pre-allocation
    matrix_during_filling = zeros(Float64, MAXDIM, MAXDIM)
    # Open the processed file for reading
    
    file = open(file_path_sorted_nosquare, "r")

    output_struct = Dict{String, Any}()
    tline = readline(file)

    while !eof(file)
        matrix_during_filling .= 0.0  # Reset all values to 0.0
        is_unread_line = true
        line_data = split(strip(tline))
        line_data = filter(!isempty, line_data)

        key = replace(line_data[1], "." => "_")
        value = nothing

        if length(line_data) == 2 && !isempty(line_data[2])  # Simple single value per run
            value = parse(Float64, line_data[2])
        elseif length(line_data) == 3 && !isempty(line_data[3]) && is_unread_line
            # Interpret the 2nd entry as indexing the filament
            coordinate1 = parse(Int, line_data[2]) + 1  # Convert C-style 0-index to Julia 1-index
            matrix_during_filling[coordinate1] = parse(Float64, line_data[3])

            maxCoordinate1 = coordinate1
            while is_unread_line && !eof(file)
                tline = readline(file)
                line_data = split(strip(tline))
                if !isempty(line_data) && line_data[1] == key
                    coordinate1 = parse(Int, line_data[2]) + 1
                    maxCoordinate1 = max(maxCoordinate1, coordinate1)
                    matrix_during_filling[1, coordinate1] = parse(Float64, line_data[3])
                else
                    is_unread_line = false
                end
            end
            value = matrix_during_filling[1, 1:maxCoordinate1]
        elseif length(line_data) == 4 && !isempty(line_data[4]) && is_unread_line
            # Interpret the 3rd entry as indexing the site
            coordinate1 = parse(Int, line_data[2]) + 1
            coordinate2 = parse(Int, line_data[3]) + 1
            matrix_during_filling[coordinate1, coordinate2] = parse(Float64, line_data[4])

            maxCoordinate1 = coordinate1
            maxCoordinate2 = coordinate2
            while is_unread_line && !eof(file)
                tline = readline(file)
                line_data = split(strip(tline))
                if !isempty(line_data) && line_data[1] == key
                    coordinate1 = parse(Int, line_data[2]) + 1
                    coordinate2 = parse(Int, line_data[3]) + 1
                    maxCoordinate1 = max(maxCoordinate1, coordinate1)
                    maxCoordinate2 = max(maxCoordinate2, coordinate2)
                    matrix_during_filling[coordinate1, coordinate2] = parse(Float64, line_data[4])
                else
                    is_unread_line = false
                end
            end
            value = matrix_during_filling[1:maxCoordinate1, 1:maxCoordinate2]
        end

        if !occursin("-", key)
            output_struct[key] = value
        end

        if is_unread_line
            tline = readline(file, keep=true)
        end
    end

    close(file)

    # Add additional properties
    if output_struct["NFil"] == 1
        output_struct["type"] = "single"
    elseif output_struct["NFil"] == 2
        output_struct["type"] = output_struct["kdimer"] == 0 ? "double" : "dimer"
    end

    # Save output structure if requested
    if saveTF
        jldsave(joinpath(output_file_path, output_fname); output_struct)
    end

    return output_struct
end
