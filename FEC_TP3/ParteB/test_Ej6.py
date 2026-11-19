from GF import *
from ReedSolomon import ReedSolomon

pol_pri_gf8_bin="00011101"
primitivo_gf8=int(pol_pri_gf8_bin,2)

gf8=GF(m=8,p_x=primitivo_gf8) 

#---------------------------------------Ejericio 6------------------------------------------------
print("\n================== Probando Ejercicio 6 ==================\n")

rs=ReedSolomon(gf8, 44, 28)

"""
1) Construccion del polinomio generador del código Reed-Solomon (44,28) sobre GF(2^8)

2) Comparación con el polinomio generador del Anexo A (comparamos los exponentes de los α) 

"""

#1) Polinomio generador del código Reed-Solomon (44,28) sobre GF(2^8)
polygen=GFPoly(gf8, rs.generador()) 

print(f"\nPolinomio generador del código Reed-Solomon ({rs.n}, {rs.k}) sobre GF(2^{gf8.m}), t={rs.t}:")
print("\ng(x) =", polygen)


#Anexo A:

"""
Anexo A (x)= α^0 x^16 + α^120 x^15 + α^104 x^14 + α^107 x^13 + α^109 x^12 + α^102 x^11 + α^161 x^10 + α^76 x^9 
            + α^3 x^8 + α^91 x^7 + α^191 x^6 + α^147 x^5 + α^169 x^4 + α^182 x^3 + α^194 x^2 + α^225 x + α^120

            
El polinomio generador del Anexo A en terminos de enteros:

Anexo A (x)= 1 x^16 + 59 x^15 + 13 x^14 + 104 x^13 + 189 x^12 + 68 x^11 + 209 x^10 + 30 x^9
            + 8 x^8 + 163 x^7 + 65 x^6 + 41 x^5 + 229 x^4 + 98 x^3 + 50 x^2 + 36 x + 59

"""

#Exponente de los α del polinomio generador del Anexo A
anexoA_exp=[0,120,104,107,109,102,161,76,3,91,191,147,169,182,194,225,120] 

#Coeficientes del polinomio generador del Anexo A en terminos de enteros

anexoA_coeficientes=[gf8.pot(2, exp) for exp in anexoA_exp] 
print(f"\nPolinomio generador del Anexo A: \n{anexoA_coeficientes}\n")

#Polinomio generador del Anexo A en terminos de enteros
polyA=GFPoly(gf8, anexoA_coeficientes)
print(f"Polinomio generador del Anexo A en terminos de enteros:\nA(x)= {polyA}\n")


#2) Comparación:
print(f"\n¿El polinomio generador obtenido es igual al polinomio generador del Anexo A")
if len(anexoA_coeficientes) != len(rs.generador()):
    print("¡aqui 1Error en el polinomio generador!")
else:
    if anexoA_coeficientes != rs.generador():
        print("¡aqui 2 Error en el polinomio generador!")
    else: 
        print(f"El polinomio generador calculado coincide con el polinomio generador del Anexo A\n\n")

"""
Codificación de un mensaje de 28 símbolos en GF(2^8) usando el código Reed-Solomon (44,28)

"""
#Mensaje:
mensaje=[ 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
         0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
         0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
         0x18, 0x19, 0x1A, 0x1B ]

poly_msg=GFPoly(gf8,mensaje)
print(f"""Polinomio del Mensaje:
      M(x)={poly_msg}""")

#Codeword
codeword=rs.codificador(mensaje)
poly_code=GFPoly(gf8,codeword)
print(f"""\nCodeword: 
        C(x)= {poly_code}""")

print("\nParidad Obtenida:\n\t", " ".join(f"{c:02X}" for c in codeword[28:]))


#Comparación de la paridad obtenida con la paridad esperada

#Paridad Esperada (del TP3):
paridad_esperada=[ 0XE8, 0X9B, 0XBB, 0X6A, 0X6F, 0X00, 0X3E, 0X3E,
                   0XC9, 0X7B, 0XC7, 0X1E, 0X8E, 0X75, 0X65, 0X38]

print("\nParidad Esperada:\n\t", " ".join(f"{c:02X}" for c in paridad_esperada))

#Comparación:
print("\n¿La paridad obtenida coincide con la paridad esperada?")
if codeword[28:] == paridad_esperada:
    print("* Si, la paridad obtenida coincide con la paridad esperada.")
else:
    print("* No, la paridad obtenida NO coincide con la paridad esperada.")

