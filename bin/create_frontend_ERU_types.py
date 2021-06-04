#!/usr/bin/python3
fout    =  open("src__root__utils__eru-types.js","w")
finp    =  open("go-api/deployments/models.py")
i       = 0
text    = "const eruTypes = {\n"

for index,line in enumerate(finp):
    x = line.strip().split("'")
    if len(x) > 0 and x[0]=='DATE_FORMAT = ':
        continue
    elif len(x) > 1:
        text += "  '" + str(i) + "': '" + x[1] + "',\n"
        i    += 1
    if i > 0 and len(x) < 2:
        break

print (text.strip(",\n") + """
};

export default eruTypes;

export function getEruType (id) {
  return eruTypes[id.toString()];
}""", file = fout)

fout.close()
finp.close()
