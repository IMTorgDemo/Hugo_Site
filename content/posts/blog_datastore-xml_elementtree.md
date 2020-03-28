
+++
title = "Working with XML Data Using Python"
date = "2020-03-26"
author = "Jason Beach"
categories = ["Introduction_Tutorial", "Data_Engineering_and_Storage"]
tags = ["xml", "python"]
+++


Together with JSON, the XML format is the most popular structure for data on the web.  It is not only used for data storage, but also for websites, in the form of HTML.  XML was seen as the ubiquitous data format, but with the ascent of Javascript, JSON became more popular for web applications.  Still, XML is an effective format, and learning to parse and work with it is necessary for anyone who works with a variety of data sources.

## Introduction to ElementTree

ElementTree is written in C (formerly cElementTree), and is part of the Python stdlib.  While the API may not be as easy as some other modules, such as minidom and beautifulsoup, ElementTree is quite fast and efficient.  Below are the results of tests performed by the ElementTree maintainers:
```
Library                         Time    Space
xml.dom.minidom (Python 2.1)    6.3 s   80000K
gnosis.objectify                2.0 s   22000k
xml.dom.minidom (Python 2.4)    1.4 s   53000k
ElementTree 1.2                 1.6 s   14500k  
ElementTree 1.2.4/1.3           1.1 s   14500k  
cDomlette (C extension)         0.540 s 20500k
PyRXPU (C extension)            0.175 s 10850k
libxml2 (C extension)           0.098 s 16000k
readlines (read as utf-8)       0.093 s 8850k
cElementTree (C extension)  --> 0.047 s 4900K <--
readlines (read as ascii)       0.032 s 5050k  
```

## Config

Begin by ensuring that your xml file is well-formed.  You can get a sense of this by visual inspection.  If the XML is not valid, then you will not be able to load the file.

```python
! ls Data/example/
```

{{< output >}}
```nb-output
example.xml
```
{{< /output >}}

```python
! head -n3 Data/example/example.xml
```

{{< output >}}
```nb-output
<?xml version="1.0"?>
<collection>
    <genre category="Action">
```
{{< /output >}}

```python
! tail -n3 Data/example/example.xml
```

{{< output >}}
```nb-output
        </decade>
    </genre>
</collection>
```
{{< /output >}}

```python
import xml.etree.ElementTree as ET
```

```python
file_path = './Data/example/example.xml'
tree = ET.parse(file_path)
```

## Explore

Continue exploring the structure of the xml.  There is typically a level of the branch where there are many leaves.  These leaves are often the data you are most interested in examining.

```python
root = tree.getroot()
```

```python
print( root )
print( root.tag )
print( root.attrib )
```

{{< output >}}
```nb-output
<Element 'collection' at 0x7fc18cd36db8>
collection
{}
```
{{< /output >}}

```python
[(x.tag, x.attrib) for x in root]
```




{{< output >}}
```nb-output
[('genre', {'category': 'Action'}), ('genre', {'category': 'Thriller'})]
```
{{< /output >}}



```python
[(x.tag, x.attrib) for idx,x in enumerate(root.iter()) if idx < 10]
```




{{< output >}}
```nb-output
[('collection', {}),
 ('genre', {'category': 'Action'}),
 ('decade', {'years': '1980s'}),
 ('movie',
  {'favorite': 'True', 'title': 'Indiana Jones: The raiders of the lost Ark'}),
 ('format', {'multiple': 'No'}),
 ('year', {}),
 ('rating', {}),
 ('description', {}),
 ('movie', {'favorite': 'True', 'title': 'THE KARATE KID'}),
 ('format', {'multiple': 'Yes'})]
```
{{< /output >}}



It looks like a path of branches gets us to our `movie` leaf.  To get there we must follow: `/genre/decade/movie`.

```python
print(ET.tostring(root, encoding='utf8').decode('utf8')[:700])
```

{{< output >}}
```nb-output
<?xml version='1.0' encoding='utf8'?>
<collection>
    <genre category="Action">
        <decade years="1980s">
            <movie favorite="True" title="Indiana Jones: The raiders of the lost Ark">
                <format multiple="No">DVD</format>
                <year>1981</year>
                <rating>PG</rating>
                <description>
                'Archaeologist and adventurer Indiana Jones 
                is hired by the U.S. government to find the Ark of the 
                Covenant before the Nazis.'
                </description>
            </movie>
               <movie favorite="True" title="THE KARATE KID">
               <format multiple="Yes">DVD,Online</format>
 
```
{{< /output >}}

## XPath Expressions

XPath is a query language used to search through an XML quickly and easily. XPath is a "path like" syntax to identify and navigate nodes in an XML document.

ElementTree has a `.findall()` function that will traverse the immediate children of the referenced element. You can use XPath expressions to specify more useful searches. 

```python
for movie in root.findall("./genre/decade/movie"):
    print(movie.attrib)
```

{{< output >}}
```nb-output
{'favorite': 'True', 'title': 'Indiana Jones: The raiders of the lost Ark'}
{'favorite': 'True', 'title': 'THE KARATE KID'}
{'favorite': 'False', 'title': 'Back 2 the Future'}
{'favorite': 'False', 'title': 'X-Men'}
{'favorite': 'True', 'title': 'Batman Returns'}
{'favorite': 'False', 'title': 'Reservoir Dogs'}
{'favorite': 'False', 'title': 'ALIEN'}
{'favorite': 'True', 'title': "Ferris Bueller's Day Off"}
{'favorite': 'FALSE', 'title': 'American Psycho'}
```
{{< /output >}}

Search on child tag.

```python
for leaf in root.findall("./genre/decade/movie/[year='1992']"):
    print(leaf.attrib)
```

{{< output >}}
```nb-output
{'favorite': 'True', 'title': 'Batman Returns'}
{'favorite': 'False', 'title': 'Reservoir Dogs'}
```
{{< /output >}}

Search on child tag's attribute

```python
for leaf in root.findall("./genre/decade/movie/format/[@multiple='Yes']"):
    print(leaf)
```

{{< output >}}
```nb-output
<Element 'format' at 0x7fc18c4e6138>
<Element 'format' at 0x7fc18c4e64a8>
<Element 'format' at 0x7fc18c4e69f8>
```
{{< /output >}}

use `...` inside of XPath to return the parent element of the current element.

```python
for leaf in root.findall("./genre/decade/movie/format/[@multiple='Yes']..."):
    print(leaf.attrib)
```

{{< output >}}
```nb-output
{'favorite': 'True', 'title': 'THE KARATE KID'}
{'favorite': 'False', 'title': 'X-Men'}
{'favorite': 'False', 'title': 'ALIEN'}
```
{{< /output >}}

## Modifying XML

### Single element

Obtain a single element of the tree and assign it to a variable.

```python
b2tf = root.find("./genre/decade/movie[@title='Back 2 the Future']")
print(b2tf)
```

{{< output >}}
```nb-output
<Element 'movie' at 0x7fc18c4e6278>
```
{{< /output >}}

```python
b2tf.attrib
```




{{< output >}}
```nb-output
{'favorite': 'False', 'title': 'Back 2 the Future'}
```
{{< /output >}}



```python
b2tf.attrib["title"] = "Back to the Future"
print(b2tf.attrib)
```

{{< output >}}
```nb-output
{'favorite': 'False', 'title': 'Back to the Future'}
```
{{< /output >}}

Because the assignment is not a deep copy, the change is made, in-place.  Now, we can write the corrected tree to file.

```python
for movie in root.findall("./genre/decade/movie"):
    print(movie.attrib)
```

{{< output >}}
```nb-output
{'favorite': 'True', 'title': 'Indiana Jones: The raiders of the lost Ark'}
{'favorite': 'True', 'title': 'THE KARATE KID'}
{'favorite': 'False', 'title': 'Back to the Future'}
{'favorite': 'False', 'title': 'X-Men'}
{'favorite': 'True', 'title': 'Batman Returns'}
{'favorite': 'False', 'title': 'Reservoir Dogs'}
{'favorite': 'False', 'title': 'ALIEN'}
{'favorite': 'True', 'title': "Ferris Bueller's Day Off"}
{'favorite': 'FALSE', 'title': 'American Psycho'}
```
{{< /output >}}

```python
import os
path = os.path.dirname(file_path)
corr_file = os.path.join(path,"example_corr.xml")
tree.write(corr_file)
```

```python
! ls Data/example
```

{{< output >}}
```nb-output
example_corr.xml  example.xml
```
{{< /output >}}

### Multiple elements

You can use regex to find commas - that will tell whether the multiple attribute should be "Yes" or "No". Adding and modifying attributes can be done easily with the .set() method.

```python
for form in root.findall("./genre/decade/movie/format"):
    print(form.attrib, form.text)
```

{{< output >}}
```nb-output
{'multiple': 'No'} DVD
{'multiple': 'Yes'} DVD,Online
{'multiple': 'False'} Blu-ray
{'multiple': 'Yes'} dvd, digital
{'multiple': 'No'} VHS
{'multiple': 'No'} Online
{'multiple': 'Yes'} DVD
{'multiple': 'No'} DVD
{'multiple': 'No'} blue-ray
```
{{< /output >}}

```python
import re
for form in root.findall("./genre/decade/movie/format"):
    # Search for the commas in the format text
    match = re.search(',',form.text)
    if match:
        form.set('multiple','Yes')
    else:
        form.set('multiple','No')
```

```python
for form in root.findall("./genre/decade/movie/format"):
    print(form.attrib, form.text)
```

{{< output >}}
```nb-output
{'multiple': 'No'} DVD
{'multiple': 'Yes'} DVD,Online
{'multiple': 'No'} Blu-ray
{'multiple': 'Yes'} dvd, digital
{'multiple': 'No'} VHS
{'multiple': 'No'} Online
{'multiple': 'No'} DVD
{'multiple': 'No'} DVD
{'multiple': 'No'} blue-ray
```
{{< /output >}}

```python
import os
path = os.path.dirname(file_path)
corr_file = os.path.join(path,"example_corr.xml")
tree.write(corr_file)
```

### Move elements

Check if movies are correctly categorized by year, and fix them if not.

```python
for decade in root.findall("./genre/decade"):
    print(decade.attrib)
    for year in decade.findall("./movie/year"):
        print(year.text, '\n')
```

{{< output >}}
```nb-output
{'years': '1980s'}
1981 

1984 

1985 

{'years': '1990s'}
2000 

1992 

1992 

{'years': '1970s'}
1979 

{'years': '1980s'}
1986 

2000 

```
{{< /output >}}

```python
for movie in root.findall("./genre/decade/movie/[year='2000']"):
    print(movie.attrib)
```

{{< output >}}
```nb-output
{'favorite': 'False', 'title': 'X-Men'}
{'favorite': 'FALSE', 'title': 'American Psycho'}
```
{{< /output >}}

Add a new decade tag to the end of the XML using the `.SubElement()` method.

```python
action = root.find("./genre[@category='Action']")
new_dec = ET.SubElement(action, 'decade')
new_dec.attrib["years"] = '2000s'

print(ET.tostring(action, encoding='utf8').decode('utf8')[:500])
```

{{< output >}}
```nb-output
<?xml version='1.0' encoding='utf8'?>
<genre category="Action">
        <decade years="1980s">
            <movie favorite="True" title="Indiana Jones: The raiders of the lost Ark">
                <format multiple="No">DVD</format>
                <year>1981</year>
                <rating>PG</rating>
                <description>
                'Archaeologist and adventurer Indiana Jones 
                is hired by the U.S. government to find the Ark of the 
                Covenant before th
```
{{< /output >}}

Use `.append()` and `.remove()` to move the element.

```python
xmen = root.find("./genre/decade/movie[@title='X-Men']")
dec2000s = root.find("./genre[@category='Action']/decade[@years='2000s']")
dec2000s.append(xmen)
dec1990s = root.find("./genre[@category='Action']/decade[@years='1990s']")
dec1990s.remove(xmen)
```

```python
print(ET.tostring(action, encoding='utf8').decode('utf8')[:500])
```

{{< output >}}
```nb-output
<?xml version='1.0' encoding='utf8'?>
<genre category="Action">
        <decade years="1980s">
            <movie favorite="True" title="Indiana Jones: The raiders of the lost Ark">
                <format multiple="No">DVD</format>
                <year>1981</year>
                <rating>PG</rating>
                <description>
                'Archaeologist and adventurer Indiana Jones 
                is hired by the U.S. government to find the Ark of the 
                Covenant before th
```
{{< /output >}}

```python
import os
path = os.path.dirname(file_path)
corr_file = os.path.join(path,"example_corr.xml")
tree.write(corr_file)
```

## XML schema (.xsd)

ElementTree does not have support for XML schema.  However, lxml library is based on ElementTree, and it does have support for schemas.  If you have access to external libraries and need the functionality, then lxml may solve your problems.

With a `XMLSchema` you can enforce the schema standards.

```python
from lxml import etree

# Create the schema object
with open(xsd_file) as f:
    xmlschema_doc = etree.parse(f)
xmlschema = etree.XMLSchema(xmlschema_doc)

# Create a tree for the XML document
doc = etree.parse(xml_text)

# Validate the XML document using the schema
return xmlschema.validate(doc)

# Or if you want a exception to be raised
xmlschema.assertValid(doc)
```

## Conclusion

Working with XML is an important skill, and Python stdlib's ElementTree library is invaluable for getting things done fast.  With a little knowledge of the ElementTree API and XPath expressions, you're fully capable of most functionality needed for XML CRUD operations.
