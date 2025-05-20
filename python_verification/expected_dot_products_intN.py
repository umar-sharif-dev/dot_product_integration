import numpy as np

DATA_TYPES = {
    'int2': 2,
    'int4': 4,
    'int8': 8,
    'int16': 16
}

def sign_extend(val, bits):
    sign_bit = 1 << (bits - 1)
    return (val & (sign_bit - 1)) - (val & sign_bit)

def float_to_hex(val):
    """Convert float32 to 8-digit hex string"""
    return format(np.frombuffer(np.float32(val).tobytes(), dtype=np.uint32)[0], '08x')

def simulate_dot_product(data_type_str):
    print(f"Simulating dot product for data type: {data_type_str}")
    shift_width = DATA_TYPES[data_type_str]
    N = 256 // shift_width

    raw_bits = np.arange(N, dtype=np.uint8)  # Simulated packed input values [0..N-1]
    signed = np.array([sign_extend(val, shift_width) for val in raw_bits], dtype=np.int16)
    A_fp32 = signed.astype(np.float32)
    x_vector = np.ones(N, dtype=np.float32)

    # Stage 0: Products
    products = A_fp32 * x_vector
    print("\nStage 0 - Products:")
    for i in range(N):
        print(f"  prod[{i:03d}] = {float_to_hex(products[i])}")

    # Adder Tree Stages
    def adder_stage(stage_num, input_vec):
        next_stage = []
        print(f"\nStage {stage_num} - {len(input_vec)//2} additions:")
        for i in range(0, len(input_vec), 2):
            if i + 1 < len(input_vec):
                summed = input_vec[i] + input_vec[i+1]
            else:
                summed = input_vec[i]
            next_stage.append(summed)
            print(f"  sum[{i//2:03d}] = {float_to_hex(summed)}")
        return np.array(next_stage)

    stages = [products]
    for stage_num in range(1, 8):
        stages.append(adder_stage(stage_num, stages[-1]))

    final = stages[-1][0]
    print(f"\nFinal Dot Product Result: {float_to_hex(final)} ({final:.1f})")

if __name__ == "__main__":
    # Example: int8 case to match Verilog
    simulate_dot_product('int8')
