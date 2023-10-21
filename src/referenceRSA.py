import random
import math
 
# A set will be the collection of prime numbers,
# where we can select random primes p and q
prime = set()
 
public_key = None
private_key = None
n = None
 
# We will run the function only once to fill the set of
# prime numbers
def primefiller():
    # Method used to fill the primes set is Sieve of
    # Eratosthenes (a method to collect prime numbers)
    seive = [True] * 250
    seive[0] = False
    seive[1] = False
    for i in range(2, 250):
        for j in range(i * 2, 250, i):
            seive[j] = False
 
    # Filling the prime numbers
    for i in range(len(seive)):
        if seive[i]:
            prime.add(i)
 
 
# Picking a random prime number and erasing that prime
# number from list because p!=q
def pickrandomprime():
    global prime
    k = random.randint(0, len(prime) - 1)
    it = iter(prime)
    for _ in range(k):
        next(it)
 
    ret = next(it)
    prime.remove(ret)
    return ret
 
 
def setkeys():
    global public_key, private_key, n
    prime1 = 63377  # First prime number
    prime2 = 61991  # Second prime number
 
    n = prime1 * prime2
    fi = (prime1 - 1) * (prime2 - 1)
 
    e = 2
    while True:
        if math.gcd(e, fi) == 1:
            break
        e += 1
 
    # d = (k*Φ(n) + 1) / e for some integer k
    public_key = e
 
    d = 2
    while True:
        if (d * e) % fi == 1:
            break
        d += 1
 
    private_key = d

    print(f"{public_key=} {private_key=} {n=}")
 

'''
Euclid's algorithm for determining the greatest common divisor
Use iteration to make it faster for larger integers
'''
def gcd(a, b):
    while b != 0:
        a, b = b, a % b
    return a

'''
Euclid's extended algorithm for finding the multiplicative inverse of two numbers
'''
def multiplicative_inverse(e, phi):
    d = 0
    x1 = 0
    x2 = 1
    y1 = 1
    temp_phi = phi
    
    while e > 0:
        temp1 = temp_phi/e
        temp2 = temp_phi - temp1 * e
        temp_phi = e
        e = temp2
        
        x = x2- temp1* x1
        y = d - temp1 * y1
        
        x2 = x1
        x1 = x
        d = y1
        y1 = y
    
    if temp_phi == 1:
        return d + phi
    
def generate_keypair(p, q):
    # if not (is_prime(p) and is_prime(q)):
    #     raise ValueError('Both numbers must be prime.')
    # elif p == q:
    #     raise ValueError('p and q cannot be equal')
    #n = pq

    n = p * q

    #Phi is the totient of n
    phi = (p-1) * (q-1)

    #Choose an integer e such that e and phi(n) are coprime
    e = random.randrange(1, phi)

    #Use Euclid's Algorithm to verify that e and phi(n) are comprime
    g = gcd(e, phi)
    while g != 1:
        e = random.randrange(1, phi)
        g = gcd(e, phi)

    #Use Extended Euclid's Algorithm to generate the private key
    d = multiplicative_inverse(e, phi)
    
    #Return public and private keypair
    #Public key is (e, n) and private key is (d, n)
    return ((e, n), (d, n))
 
# To encrypt the given number
def encrypt(message):
    global public_key, n
    e = public_key
    encrypted_text = 1
    while e > 0:
        encrypted_text *= message
        encrypted_text %= n
        e -= 1
    return encrypted_text
 
 
# To decrypt the given number
def decrypt(encrypted_text):
    global private_key, n
    d = private_key
    decrypted = 1
    while d > 0:
        decrypted *= encrypted_text
        decrypted %= n
        d -= 1
    return decrypted
 
 
# First converting each character to its ASCII value and
# then encoding it then decoding the number to get the
# ASCII and converting it to character
def encoder(message):
    encoded = []
    # Calling the encrypting function in encoding function
    for letter in message:
        encoded.append(encrypt(ord(letter)))
    return encoded
 
 
def decoder(encoded):
    s = ''
    # Calling the decrypting function decoding function
    for num in encoded:
        s += chr(decrypt(num))
    return s
 
 
# if __name__ == '__main__':
#     primefiller()
#     setkeys()
#     message = "Test Message"
#     # Uncomment below for manual input
#     # message = input("Enter the message\n")
#     # Calling the encoding function
#     coded = encoder(message)
 
#     print("Initial message:")
#     print(message)
#     print("\n\nThe encoded message(encrypted by public key)\n")
#     print(''.join(str(p) for p in coded))
#     print("\n\nThe decoded message(decrypted by public key)\n")
#     print(''.join(str(p) for p in decoder(coded)))