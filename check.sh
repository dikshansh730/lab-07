
#!/bin/bash

all_pass=1

for num in 1 2 3 4; do
    input_dir="Testcase${num}"
    output_dir="Testcase${num}Diff"
    passed=1
    differences=0

    for file1 in "$input_dir"/*.1.txt; do
        [ -f "$file1" ] || continue

        file2="${file1%.1.txt}.2.txt"
        name="${file1##*/}"
        name="${name%.1.txt}"
        output_file="$output_dir/${name}Diff.txt"

        if ! cmp -s "$file1" "$file2"; then
            differences=$((differences + 1))

            if [ ! -f "$output_file" ]; then
                passed=0
            elif ! diff -u \
                <(diff -u "$file1" "$file2" | tail -n +3) \
                <(tail -n +3 "$output_file") > /dev/null; then
                passed=0
            fi
        else
            if [ -f "$output_file" ]; then
                passed=0
            fi
        fi
    done

    if [ "$differences" -eq 0 ]; then
        if [ -d "$output_dir" ]; then
            passed=0
        fi
    else
        if [ ! -d "$output_dir" ]; then
            passed=0
        else
            for output_file in "$output_dir"/*; do
                [ -e "$output_file" ] || continue
                name="${output_file##*/}"
                name="${name%Diff.txt}"

                if [ ! -f "$input_dir/${name}.1.txt" ] || \
                   [ ! -f "$input_dir/${name}.2.txt" ]; then
                    passed=0
                fi
            done
        fi
    fi

    if [ "$passed" -eq 1 ]; then
        echo "Testcase${num}: PASS"
    else
        echo "Testcase${num}: FAIL"
        all_pass=0
    fi
done

if [ "$all_pass" -eq 1 ]; then
    exit 0
else
    exit 1
fi
