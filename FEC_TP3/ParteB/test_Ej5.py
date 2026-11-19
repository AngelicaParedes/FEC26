from GF import *
from ReedSolomon import ReedSolomon


#---------------------------------------Ejericio 5------------------------------------------------
print("\n================== Probando Ejercicio 5 ==================\n")

"""
Cuerpo de Galois 2^8
Polinomio primitivo: 
    P(x) = X^8+X^4+1 -> bin: 1|00011101 -> dec=17 (sin el término X^m)
"""

pol_pri_gf8_bin="00011101"
primitivo_gf8=int(pol_pri_gf8_bin,2)

gf8=GF(m=8,p_x=primitivo_gf8) 
print (f"-----------Cuerpo de Galois (2^{gf8.m})-----------")
print(f"""Polinomio primitivo: 
        P(x) = X^8+X^4+X^3+X^2+1 
        p={gf8.p_x} (binario:{bin(gf8.p_x)}) sin el termino x^{gf8.m}""")

print(f"Los elementos van de 0 a {gf8.mask}\n")

"""
Cuerpo de Galois 2^4
Polinomio primitivo: 
    P(x)=X^4+X+1 -> bin:1|0011 -> dec=3 (sin el término X^m)
"""

pol_pri_gf4_bin="0011"
primitivo_gf4=int(pol_pri_gf4_bin,2)

gf4=GF(m=4,p_x=3) 
print (f"-----------Cuerpo de Galois (2^{gf4.m})-----------")
print (f"""Polinomio primitivo: 
       P(x)=X^4+X+1 
       p={gf4.p_x} (binario:{bin(gf4.p_x)}) sin el termino x^{gf4.m}""")

print(f"Los elementos van de 0 a {gf4.mask}\n")


"""

1) Verificación de que la función orden_de_elemento() me devuelva el orden de los elementos

2) Verificación de que alfa es de orden 2^m-1 en ambos cuerpos de Galois

"""
#Verificacion 1:
print("\n1)Verificación de que la función orden_de_elemento() me devuelva el orden de los elementos:\n")

alfa_5_bin="0110" #alfa^5
alfa_5=int(alfa_5_bin,2)

print(f"Para el cuerpo de Galois GF(2^{gf4.m}):")
print(f"\tEl orden de elemento α^5=α^2 +α : {gf4.orden_de_elemento(alfa_5)}\n")

#Verificación 2:
print("2)Verificación de que α es de orden 2^m-1 en ambos cuerpos de Galois:\n")

print (f"-----------Cuerpo de Galois (2^{gf8.m})-----------")
print(f"\tOrden de elemento α: {gf8.orden_de_elemento(2)}\n")


print (f"-----------Cuerpo de Galois (2^{gf4.m})-----------")
print(f"\tOrden de elemento α: {gf4.orden_de_elemento(2)}\n")


"""

Derivada formal de polinomios sobre GF(2^m)

"""

print(f"\nPruebas de la derivada formal de polinomios en GF(2^{gf4.m}):\n")
F=[1,13,1]  
G=[15,3,1]   
H=[3,2,1]
K=[1,1,0,1,1]

poly1=GFPoly(gf4,F)
poly2=GFPoly(gf4,G)
poly3=GFPoly(gf4,H)
poly4=GFPoly(gf4,K)

derivada_poly1 = poly1.derivada()
print(f"F'(X)= {poly1} \nSu derivada formal es: {derivada_poly1}")

derivada_poly2 = poly2.derivada()
print(f"\nG'(X)= {poly2} \nSu derivada formal es: {derivada_poly2}")

derivada_poly3 = poly3.derivada()
print(f"\nH'(X)= {poly3} \nSu derivada formal es: {derivada_poly3}")

derivada_poly4 = poly4.derivada()
print(f"\nK'(X)= {poly4} \nSu derivada formal es: {derivada_poly4}")


