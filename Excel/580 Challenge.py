fibs = [0, 1]
[fibs.append(fibs[-1] + fibs[-2]) for _ in range(18)]
print(max(fibs, key=lambda n: eval('*'.join(str(n)))))

