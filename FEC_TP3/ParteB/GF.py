class GF:
    def __init__(self, m: int, p_x: int):
        
        self.m = m   #orden del campo
        self.p_x = p_x  #polinomio primitivo representado como entero de m bits
        self.order = 2** m  # 2^m
        self.mask = self.order - 1  #2^m-1


    def validar_elemento(self, elem: int):
        if not (0 <= elem < self.order):
            raise ValueError(f"El elemento {elem} no pertenece a GF(2^{self.m})")


    #Suma (y resta) en GF(2^m): operación XOR bit a bit.
    def sum(self, a: int, b: int) -> int:
        self.validar_elemento(a)
        self.validar_elemento(b)
        return a ^ b

    #Multiplicación en GF(2^m) usando desplazamientos y reducción por el polinomio primitivo.
    def mul(self, a: int, b: int) -> int:
        self.validar_elemento(a)
        self.validar_elemento(b)

        result = 0
        
        for _ in range(self.m):
            if (b & 1):
                result ^= a
            
            # Verifica si el bit m-1 de 'a' está activo antes de desplazar
            carry = a & (1 << (self.m - 1))
            a <<= 1  

            if carry:
                # Se aplica XOR con el polinomio primitivo completo (x^m + p_x)
                a ^= self.p_x

            b >>= 1

        return result & self.mask

#Potencia 
    def pot(self, base: int, exp: int) -> int:
        self.validar_elemento(base)
        if exp<0:
            raise ValueError("El exponente debe ser mayor o igual a 0")
        res = 1
        for _ in range(exp):
            res = self.mul(res, base)
        return res

#Inverso multiplicativo 
#a^(-1) = a^(2^m - 2) en GF(2^m).

    def inv(self, a: int) -> int:
        self.validar_elemento(a)
        if a == 0:
            raise ZeroDivisionError("El elemento 0 no tiene inverso multiplicativo en GF(2^m).")
        return self.pot(a, self.order - 2)

#División a/b
    def div(self, a: int, b: int) -> int:
        self.validar_elemento(a)
        self.validar_elemento(b)
        if b == 0:
            raise ZeroDivisionError("División por cero no permitida en GF(2^m).")
        return self.mul(a, self.inv(b))

#Orden de un elemento a en GF(2^m): el menor entero positivo n tal que a^n = 1.
    def orden_de_elemento(self, a: int) -> int:
        self.validar_elemento(a)
        if a == 0:
            raise ValueError("El elemento 0 no tiene orden en GF(2^m).")
        
        n = 1
        current = a
        while current != 1:
            current = self.mul(current, a)
            n += 1
            if n > self.order:  # Evita bucles infinitos
                raise ValueError(f"No se encontró el orden de {a} en GF(2^{self.m}).")
        
        return n



#------------------Polinomios sobre GF(2^m)----------------------------
class GFPoly:
    def __init__(self, gf: GF, coeffs: list[int]):
        
        #Representa un polinomio con coeficientes en GF(2^m).
        # Parámetro gf: Instancia de la clase GF.
        # Parámetro coeffs: Lista de coeficientes en orden decreciente de grado [a_n, ..., a_0].
        
        self.gf = gf

        # Validar que cada elemento sea un elemento válido del campo GF(2^m)
        for c in coeffs:
            self.gf.validar_elemento(c)

        # Eliminar ceros a la izquierda 
        i = 0
        while i < len(coeffs) - 1 and coeffs[i] == 0:
            i += 1
        
        self.coeffs = list(coeffs[i:]) if coeffs else [0]

    @property
    def grado(self) -> int:
        if self.coeffs == [0]:
            return -1
        return len(self.coeffs) - 1

    def validar_campos (self, other: "GFPoly") -> "GFPoly":
        if self.gf != other.gf:
            raise ValueError("Los polinomios deben estar sobre el mismo campo GF.")


    #SUMA
    def suma(self, other: "GFPoly") -> "GFPoly":
        self.validar_campos (other)

        len1, len2 = len(self.coeffs), len(other.coeffs)
        max_len = max(len1, len2)

        # Alinear coeficientes agregando ceros a la izquierda
        p1 = [0] * (max_len - len1) + self.coeffs
        p2 = [0] * (max_len - len2) + other.coeffs

        res_coeffs = [self.gf.sum(a, b) for a, b in zip(p1, p2)]
        return GFPoly(self.gf, res_coeffs)


    #PRODUCTO
    def producto(self, other: "GFPoly") -> "GFPoly":
        self.validar_campos (other)

        if self.grado == -1 or other.grado == -1:
            return GFPoly(self.gf, [0])

        res_len = len(self.coeffs) + len(other.coeffs) - 1
        res = [0] * res_len

        for i, c1 in enumerate(self.coeffs):
            for j, c2 in enumerate(other.coeffs):
                prod = self.gf.mul(c1, c2)
                res[i + j] = self.gf.sum(res[i + j], prod)

        return GFPoly(self.gf, res)


    #DIVISION entera de dos polinomios, obteniendo por separado el cociente y el resto
    def divmod(self, other: "GFPoly") -> tuple["GFPoly", "GFPoly"]:
        self.validar_campos (other)

        if other.grado == -1:
            raise ZeroDivisionError("División entera por el polinomio nulo.")

        if self.grado < other.grado:
            print(f"El grado del polinomio F(X)=({other}) es {other.grado}")
            print(f"menor que el grado del divisor G(X)={self} el cual es {self.grado}")
            return GFPoly(self.gf, [0]), GFPoly(self.gf, self.coeffs)

        rem = list(self.coeffs)
        deg_divisor = other.grado #Grado del divisor
        lead_b = other.coeffs[0]

        cociente = [0] * (len(rem) - deg_divisor)

        while len(rem) - 1 >= deg_divisor and rem != [0]:
            shift = len(rem) - 1 - deg_divisor
            coeff = self.gf.div(rem[0], lead_b)
            cociente[len(cociente) - 1 - shift] = coeff

            # Restar (sumar) coeff * other * x^shift
            for i, c in enumerate(other.coeffs):
                prod = self.gf.mul(coeff, c)
                rem[i] = self.gf.sum(rem[i], prod)

            # Quitar ceros principales
            while len(rem) > 1 and rem[0] == 0:
                rem.pop(0)

        return GFPoly(self.gf, cociente), GFPoly(self.gf, rem)

    

    def floordiv(self, other: "GFPoly") -> "GFPoly":
        return self.divmod(other)[0]
    

    #Resto
    def mod(self, other: "GFPoly") -> "GFPoly":
        return self.divmod(other)[1]

    
    #ESCALADO: multiplicar todos los coeficientes de un polinomio por un escalar del campo
    def scale(self, scalar: int) -> "GFPoly":
        self.gf.validar_elemento(scalar)
        if scalar == 0:
            return GFPoly(self.gf, [0])
        return GFPoly(self.gf, [self.gf.mul(c, scalar) for c in self.coeffs])


    #EVALUACIÓN del polinomio en un punto x perteneciente a GF(2^m)
    def eval(self, x: int) -> int:
        self.gf.validar_elemento(x)
        res = 0
        for c in self.coeffs:
            res = self.gf.sum(self.gf.mul(res, x), c)
        return res


    #Raíces
    @classmethod
    def desde_raices(cls, gf: GF, raices: list[int]) -> "GFPoly":

        #Construye el polinomio P(x)=(x - r1)(x - r2)... a partir de una lista de raíces.

        poly = cls(gf, [1])  # Polinomio unitario P(x) = 1

        for r in raices:
            gf.validar_elemento(r)
            term = cls(gf, [1, r]) #Crea el factor (X+r)
            poly = poly * term
        return poly


    #Igualdad
    def eq(self, other: object) -> bool:
        if not isinstance(other, GFPoly):
            return False
        return self.gf == other.gf and self.coeffs == other.coeffs


    #Derivada formal del polinomio
    def derivada(self) -> "GFPoly":
        if self.grado <= 0:
            return GFPoly(self.gf, [0])

        deriv_coeffs = []
        for i in range(len(self.coeffs) - 1):
            coeff = self.coeffs[i]
            power = self.grado - i
            if power % 2 == 1:  # Solo se consideran los términos con exponente impar
                deriv_coeffs.append(coeff)
            else:
                deriv_coeffs.append(0)

        return GFPoly(self.gf, deriv_coeffs)


    #Representación en forma de Polinomio
    def __repr__(self) -> str:
        if self.coeffs == [0]:
            return "0"
        deg = len(self.coeffs) - 1
        terms = []
        for i, c in enumerate(self.coeffs):
            power = deg - i
            if c != 0:
                if power == 0:
                    terms.append(f"{c}")
                elif power == 1:
                    terms.append(f"{c}x" if c != 1 else "x")
                else:
                    terms.append(f"{c}x^{power}" if c != 1 else f"x^{power}")
        return " + ".join(terms)




