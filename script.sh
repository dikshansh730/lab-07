
#!/bin/bash

for num in 1 2 3 4; do
    input_dir="Testcase${num}"
    output_dir="Testcase${num}Diff"

    rm -rf "$output_dir"

    for file1 in "$input_dir"/*.1.txt; do
        [ -f "$file1" ] || continue

        file2="${file1%.1.txt}.2.txt"
        [ -f "$file2" ] || continue

        name="${file1##*/}"
        name="${name%.1.txt}"

        if ! cmp -s "$file1" "$file2"; then
	    mkdir -p "$output_dir"
    	    diff -u "$file1" "$file2" > "$output_dir/${name}Diff.txt"
	fi
    done
done
