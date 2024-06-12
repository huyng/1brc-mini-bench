from collections import defaultdict

if __name__ == "__main__":
    totals = defaultdict(float)
    counts = defaultdict(int)
    with open("../../data/measurements-10000000.txt", "r") as fh:
        for line in fh:
            city, temp = line.strip().split(";")
            temp = float(temp)
            totals[city] += temp
            counts[city] += 1

    for city, total in sorted(totals.items()):
        print("%s: %.3f" % (city, total/counts[city]))
