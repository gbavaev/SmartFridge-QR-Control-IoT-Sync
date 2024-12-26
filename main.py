import qrcode
s1 = input("Название: ")
s2 = input("Тип: ")
s3 = input("Дата изготовления: ")
s4 = input("Дата истечения срока годности: ")
s5 = input("Масса/Объём: ")
s6 = input("Пищевая ценность: ")
s7 = input("Вес/Количество: ")
data = s1 + "*" + s2 + "*" + s3 + "*" + s4 + "*" + s5 + "*" + s6 + "*" + s7
filename = "site.png"
img = qrcode.make(data)
img.save(filename)