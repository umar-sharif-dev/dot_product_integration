import numpy as np

def generate_expected_dot_products():
    results = []
    for base in range(64):
        A = np.arange(base, base + 32, dtype=np.int8)  # 32 elements
        x_vector = np.ones(32, dtype=np.float32)       # 32 ones
        dot = np.dot(A.astype(np.float32), x_vector)
        hex_val = hex(np.frombuffer(dot.tobytes(), dtype=np.uint32)[0])
        results.append((base, int(dot), float(dot), hex_val))

    print(f"{'Row':>5} | {'Sum':>6} | {'Float':>10} | {'FP32 Hex':>10}")
    print("-" * 40)
    for row, int_sum, flt_sum, hex_str in results:
        print(f"{row:>5} | {int_sum:>6} | {flt_sum:>10.1f} | {hex_str:>10}")

if __name__ == "__main__":
    generate_expected_dot_products()
