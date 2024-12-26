import cv2
tverd = list(i for i in open("main.txt"))
jidk = list(i for i in open("main2.txt"))
razves = list(i for i in open("main3.txt"))
img = cv2.imread("site.png")
detector = cv2.QRCodeDetector()
data, bbox, straight_qrcode = detector.detectAndDecode(img)
if bbox is not None:
    img = data.split("*")
    if img[1] in tverd:
        print("Название: " + img[0] + "\nТип: " + img[1] + "\nДата изготовления: " + img[2] + "\nДата истечения срока годности: " + img[3] + "\nМасса: " + img[4] + "кг\nПищевая ценность: " + img[5] + "ккал\nКоличество: " + img[6] + "шт")
    elif img[1] in jidk:
        print("Название: " + img[0] + "\nТип: " + img[1] + "\nДата изготовления: " + img[2] + "\nДата истечения срока годности: " + img[3] + "\nОбъём: " + img[4] + "л\nПищевая ценность: " + img[5] + "ккал\nКоличество: " + img[6] + "шт")
    elif img[1] in razves:
        print("Название: " + img[0] + "\nТип: " + img[1] + "\nДата изготовления: " + img[2] + "\nДата истечения срока годности: " + img[3] + "\nМасса: " + img[4] + "кг\nПищевая ценность: " + img[5] + "ккал\nВес: " + img[6] + "кг")
