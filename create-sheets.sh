#!/bin/bash

PDFFILE="card-builder.pdf"

# Get Last Page
lastpage=$(($(pdfinfo ${PDFFILE} | awk '/^Pages:/ {print $2}')-1))
# -colorspace RGB
sudo convert -dither FloydSteinberg -density 500 "${PDFFILE}" temp%d.png > /dev/null

STEPSIZE=70
START=0
for (( I=$STEPSIZE; I<=$lastpage+$STEPSIZE-1; I+=$STEPSIZE )) do
    END=$(($I>$lastpage ? $lastpage : $I-1))
    echo $START--$END
    eval sudo montage -tile 10x7 -geometry 400x500+0+0 temp{$START..$END}.png cards-${START}-$END.png
    START=$I
done

echo Cleanup
sudo rm temp*.png