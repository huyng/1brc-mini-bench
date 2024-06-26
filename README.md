# 1brc-mini-bench

Benchmark 1brc challenge but with following simplified rules:

1. Instead of the full 1B rows, we operate only on 10M data rows located in <a href="data/measurements-10000000.txt">data/measurements-10000000.txt</div>
2. Just calculate the average temp for each city.

The output of the results should be sent to stdout with the following format for each city separated by newline:

    city: averageTemp

## Results

|  submission   | time          |
| ------------- | ------------- |
| simple_python | 14.816s       |
| simple_zig    | 2.045s        |
| simple_go     | 2.568s        |

## How to submit an entry

1. Checkout repo
2. Create directory under `submissions/<name_of_submission>`
3. Write a `run.sh` wherein you call the `time` command on your code to run the calculation.
4. Send a pull request. Your code should generally be executable within a Docker ubuntu:22.04 container
