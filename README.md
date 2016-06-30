# Get specimens' descriptions and images from NYBG's virtual herbarium

This is a very simple R package to grab descriptions from NYBG's virtual herbarium:

![NYBG specimen page](http://i.imgur.com/WQl88kM.png)

For some reason, the data distributed through GBIF includes only the link to the specimen's page in the description field, not the description itself. This package will help you grab the description and images of any given specimen:

```coffee
devtools::install_github('gustavobio/rnybg')
get_description(1184769)
[1] "Arvoreta de aproxidamente três a quatro metros. Flores esverdeadas. Phenology of specimen: Flower."

get_specimen_url(1184769)
                                                   url 
"http://sweetgum.nybg.org/vh/specimen.php?irn=1478224" 

get_image_url(1889108)
[1] "http://sweetgum.nybg.org/images3/1019/294/01889108.jpg"

open_image(1184769)

download_image(1184769)
```
