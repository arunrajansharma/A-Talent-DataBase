(:
Author : Arun Rajan, Stony Brook University
I pledge my honor that all parts of this project were done by me alone and without collaboration with anybody else. 
:)
xquery version "3.1";
declare namespace xsd = "http://www.w3.org/2001/XMLSchema";
declare namespace xsi ="http://www.w3.org/2001/XMLSchema-instance";
declare namespace myNS = "proj3ns";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "html5";
declare option output:media-type "text/html";
<html>
    <body>
        <ul>{
                for $c1 in doc("tdb3.xml")//myNS:contestant
                for $c2 in doc("tdb3.xml")//myNS:contestant
                for $aud1 in $c1//myNS:audition
                for $aud2 in $c2//myNS:audition
                let $count1 := count($aud1//myNS:score/@value)
                let $avg1 := avg($aud1//myNS:score/@value)
                let $count2 := count($aud2//myNS:score/@value)
                let $avg2 := avg($aud2//myNS:score/@value)
                where $aud2/myNS:aid = $aud1/myNS:aid
                      and $count2 = $count1
                      and $avg2 = $avg1
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