#!/usr/bin/python3
fout    =  open("ids_in.svg","w")
finp    =  open("orig.svg")
i       = 1
text    = ''

for index,line in enumerate(finp):
    x = line.strip().split(" ")
    if x[0]=='<rect':
        x[0]+= ' id="' + str(i) + '" className="svgPointerEvent"'
        i += 1
        text += ' '.join(x) + "\n"
    else:
        text += line

print (text, file = fout)

fout.close()
finp.close()
