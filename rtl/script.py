s = [0] * 256
for t in range(256):
    s[t] = t

j = 0
secret_key = "000000000000001001001001"  

# Convert the reversed binary string to a list of integers 
secret_key_bytes = [int(secret_key[i:i+8], 2) for i in range(0, len(secret_key), 8)]
print(secret_key_bytes)

for i in range(255):
    j = (j + s[i] + secret_key_bytes[i % 3]) % 256
    s[i], s[j] = s[j], s[i]

# secret_key = secret_key[::-1]  # reverse the secret key (cause in python kinda oposite to verilog ?)
# for i in range(255):
#     j = (j + s[i] + int(secret_key[i % 24])) % 256
#     s[i], s[j] = s[j], s[i]


# transform and write the hex values to a file  dw about this part
hex_values = [format(x, '02X') for x in s]
with open('rtl/script_out.txt', 'w') as file:
    for i, hex_value in enumerate(hex_values):
        file.write(hex_value)
        if (i + 1) % 16 == 0:
            file.write('\n')
        else:
            file.write(' ')


