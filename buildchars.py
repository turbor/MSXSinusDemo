# one bit of subpixel precision
import time
subpix = 2
charindex = 2
chardict = dict()
chardict[0]="#00,#00,#00,#00,#00,#00,#00,#00"
chardict[1]="#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff"



def mk8x8(yoffs, a, b, c):
    arr = [0 for x in range(8 * 8)]
    for y in range(0, 8):
        yy = (y + yoffs) * subpix
        for x in range(0, 8):
            xx = x * subpix
            if a * xx + b * yy + c >= 0.0:
                arr[x + y * 8] = 1
    db = list()
    for y in range(0, 8):
        print '&b'+''.join(str(x) for x in arr[y * 8: y*8+8])
        d = '#' + format(int(''.join(str(x) for x in arr[y * 8: y*8+8]),2 ) ,'02x')
        db.append(d)
    char = ','.join(db)
    print " db " + char
    print
    return char

def construct_fill_table():
    x0 = 0
    x1 = 8 * subpix
    fill_tbl = [None for x in range(8 * subpix)]
    for y0 in range(0, 8 * subpix):
        fill_tbl[y0] = [None for x in range(0, 8 * subpix)]
        for yi1 in range(-4 * subpix, 4 * subpix):
            y1 = y0 + yi1
            a = -(y1 - y0)
            b = (x1 - x0)
            c = -(a * x0 + b * y0)
            print "y0 " + str(y0/subpix) + "  y1 "+str(y1/subpix)
            chr_a = mk8x8(-8, a, b, c)
            chr_b = mk8x8(0, a, b, c)
            chr_c = mk8x8(8, a, b, c)
            # time.sleep(1)
            fill_tbl[y0][yi1 + 4 * subpix] = [chr_a, chr_b, chr_c]
    return fill_tbl

def make_charlist_from_fill_table(fill_tbl):
    charhash = dict()
    count = 0
    global charindex
    for y0 in range(0, 8 * subpix):
        for yi1 in range(-4 * subpix, 4 * subpix):
            driechars = fill_tbl[y0][yi1 + 4 * subpix]
            print
            for c in driechars:
               if c == "#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff" or c == "#00,#00,#00,#00,#00,#00,#00,#00":
                   print "full or empty so skip"
               else:
                   if not charhash.has_key(c):
                        charhash[c]=charindex
                        print str(charindex) + "   " + c
                        charindex += 1
                   else:
                       print "found already "+str(charhash[c])
            count = count +3
    print str(count) + " count"
    for key, value in charhash.items():
        chardict[value]=key




if __name__ == '__main__':
    fill = construct_fill_table()
    make_charlist_from_fill_table(fill)
    print len(fill)
    print len(fill[0])
    print fill
    print
    print
    for i in range(0, charindex):
        print " db "+chardict[i]+ "  ; " +str(i)



