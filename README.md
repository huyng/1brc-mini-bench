# 1brc-mini-bench

Benchmark 1brc challenge but with following simplified rules:

1. Only 10M data rows located in <a href="blob/main/data/measurements-10000000.txt">data/measurements-10000000.txt</div>
2. Just calculate the average temp for each city.

The output of the results should be sent to stdout with the following format for each city separated by newline:

    city: averageTemp

# Results

|  submission   | time (secs)   |
| ------------- | ------------- |
| simple_python | 14.816s       |

# How to submit an entry

1. Checkout repo
2. Create directory under `submissions/<name_of_submission>`
3. Write a `run.sh` wherein you call the `time` command on your code to run the calculation.