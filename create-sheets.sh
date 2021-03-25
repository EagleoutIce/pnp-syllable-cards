#!/bin/bash

PDFFILE="card-builder.pdf"

# Get Last Page
lastpage=$(($(pdfinfo ${PDFFILE} | awk '/^Pages:/ {print $2}')-1))
# -colorspace RGB
convert -dither FloydSteinberg -density 550 "${PDFFILE}" temp%d.png > /dev/null

STEPSIZE=70
START=0
WIDTH=500
HEIGHT=776
for (( I=$STEPSIZE; I<=$lastpage+$STEPSIZE-1; I+=$STEPSIZE )) do
    END=$(($I>$lastpage ? $lastpage : $I-1))
    echo $START--$END
    eval montage -tile 10x7 -geometry ${WIDTH}x${HEIGHT}+0+0 temp{$START..$END}.png cards-${START}-$END.png
    START=$I
done

echo Cleanup
rm temp*.png