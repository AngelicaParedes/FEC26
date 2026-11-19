from GF import GF, GFPoly

class ReedSolomon:
    def __init__(self, gf:GF, n:int, k:int):
        self.gf = gf
        self.n = n
        self.k = k
        self.t = (n - k) // 2  # Número máximo de errores corregibles
    

    def generador(self):

        nsym = self.n - self.k #16
        g = [1]     #g(x)=1
        alpha_i = 1  # alpha^0

        # g(x)* (x - alpha^i) = g(x) * x + alpha^i * g(x)

        for i in range(nsym):

            alpha_i = self.gf.pot(2, i)  # alpha^i
            nuevo = g + [0]                  # g(x) * x

            for j, c in enumerate(g):
                nuevo[j + 1] ^= self.gf.mul(c, alpha_i)   # + alpha^i * g(x)
            
            g = nuevo
            alpha_i = self.gf.mul(alpha_i, 2)     # siguiente potencia de alpha

        return g



    def codificador(self, msg)-> list[int]:

        nsym = self.n - self.k  # n-k = 16 símbolos de paridad

        if len(msg) != self.k:
            raise ValueError(f"El mensaje debe tener {self.k} símbolos")

        """

        Codificacion sistematica:
        1) Desplazamos el mensaje a la izquierda n-k posiciones (multiplicamos por x^(n-k))
        2) Dividimos el polinomio desplazado por el polinomio generador g(x)
        3) El resto de la división es la paridad, que se agrega al final del mensaje original para formar el código Reed-Solomon

        Nota: Trabajo con polinomios

        """

        # Polinomio desplazado del mensaje (multiplicado por x^(n-k))
        x_msg=GFPoly(self.gf, list(msg)+[0]*nsym)  

        #Polinomio Generador
        poly_g = GFPoly(self.gf, self.generador())  

        #La paridad es el resto de la división del polinomio desplazado del mensaje por el polinomio generador
        _,resto = x_msg.divmod(poly_g) 

        paridad = [0] * (nsym - len(resto.coeffs)) + resto.coeffs

        return list(msg) + paridad                     # mensaje + paridad