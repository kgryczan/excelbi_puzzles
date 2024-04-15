import pandas as pd
import numpy as np
import numpy as np
 
n = 100
seq = np.arange(1, n+1)
cumulative_sum = np.cumsum(seq)
indices = cumulative_sum - seq + 1

def num_to_letter(y):
    import numpy as np

    def jfun(div):
        if np.isnan(div):
            return None

        ret = []
        while div > 0:
            remainder = (div - 1) % 26 + 1
            ret.insert(0, remainder)
            div = (div - remainder) // 26
        return ''.join([chr(r + 64) for r in ret])

    y = np.array(y, ndmin=1)
    ret = np.vectorize(jfun)(y)

    ret[ret == ''] = None
    return ret if len(ret) > 1 else ret[0]

cols = num_to_letter(indices)
matrix = np.reshape(cols, (5,20)).T 
print(matrix)

