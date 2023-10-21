import json

# Sample data
data = {
    "name": "John",
    "age": 30,
    "city": "New York"
}

data = {
"a": 3
}
# Serialize JSON to string
json_string = json.dumps(data)

# Convert the string to bytes
byte_representation = json_string.encode('utf-8')

print(byte_representation)
print(byte_representation.hex())
