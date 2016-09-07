#!/usr/bin/env python3

from bs4 import BeautifulSoup
import sys

def find(parent_name, parent_tag, child_tag_name, child_tag_attrs={}):
    child_tags = parent_tag.findAll(child_tag_name, child_tag_attrs)
    if (len(child_tags) > 0):
        return child_tags
    else:
        print("No {} tags found in {}".format(child_tag_name, parent_name), file=sys.stderr)
        exit(-2)


if (len(sys.argv) != 2):
    print("Usage:\t{} file.html".format(sys.argv[0]))
    exit(-1)

html = BeautifulSoup(open(sys.argv[1]), "lxml")

# Determine book and chapter

verse_start=-1
verse_end=-1

for chapter in find("html", html, "div", {"class" : "chapter"}):
    chapter_id = chapter.get("id").split(".")
    book_abbrev = chapter_id[0]
    chapter_number = chapter_id[1].zfill(2)
    for paragraph_number, paragraph in enumerate(find("{} {}".format(book_abbrev, chapter_number), chapter, "p")):
        for verse in find("{} {}, paragraph {}".format(book_abbrev, chapter_number, paragraph_number), paragraph, "span"):
            if (hasattr(verse, "contents") and verse.has_attr("class")):
                if (hasattr(verse.contents[0], "sup")):
                    verse_numbers = verse.contents[0].contents[0].split("-")
                    verse_start = verse_numbers[0].zfill(2)
                    verse_end   = verse_numbers[-1].zfill(2)
                    verse_content = verse.contents[1]
                else:
                    verse_content = verse.contents[0]

                print("{}\t{}\t{}\t{}\t{}".format(book_abbrev, chapter_number, verse_start, verse_end, verse_content))
