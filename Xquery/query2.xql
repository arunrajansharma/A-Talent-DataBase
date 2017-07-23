(:
Author : Arun Rajan, Stony Brook University
I pledge my honor that all parts of this project were done by me alone and without collaboration with anybody else. 
:)
xquery version "3.1";
declare namespace xsd = "http://www.w3.org/2001/XMLSchema";
declare namespace xsi ="http://www.w3.org/2001/XMLSchema-instance";
declare namespace myNS = "proj3ns";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace functx = "http://www.functx.com";
declare option output:method "html5";
declare option output:media-type "text/html";
<html>
    <body>
        <ul>
            {
                for $c1 in doc("tdb3.xml")//myNS:contestant
                for $c2 in doc("tdb3.xml")//myNS:contestant
                for $aud1 in $c1//myNS:audition
                for $aud2 in $c2//myNS:audition
                let $max1 := max($aud1//myNS:score/@value)
                let $min1 := min($aud1//myNS:score/@value)
                let $max2 := max($aud2//myNS:score/@value)
                let $min2 := min($aud2//myNS:score/@value)
                where $aud2/myNS:aid = $aud1/myNS:aid
                      and $max2 = $max1
                      and $min2 = $min1
                      and $c2/myNS:cname > $c1/myNS:cname
                order by $c1/myNS:cname,$c2/myNS:cname
                return 
                        <li>
                        {$c1/myNS:cname}
                        {$c2/myNS:cname}
                        </li>
            }
        </ul>
    </body>
</html>