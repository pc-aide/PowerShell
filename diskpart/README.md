# diskpart

---

## Clean
1. list disk
2. select disk <number>
3. clean

---

## Format
1. convert mbr
2. create partition primary
3. select partition 1
4. active
5. format fs=ntfs quick
  * optional : label=myData after param fs=
  * optional : assign letter=g after format

<img src="https://i.imgur.com/MT99pHH.png">
