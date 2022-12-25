from PIL import Image
import numpy as np

im = Image.open('./namu.jpg')
im_resize = im.resize((160,120))

col, row = im_resize.size
im_resize = im_resize.convert('L')
pix = np.array(im_resize)
im_resize.show()
f = open('./namu.hex','wt')

for idy in range(row):
    for idx in range(col) :
        f.write('%0x\n' %(pix[idy][idx]))
f.close()