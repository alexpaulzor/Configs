#!/usr/bin/python2

import argparse
import re
from subprocess import *

class Target:
    def __init__(self, name, section = 'aur', version = '1.0', description = [], vote = None, obsolete = False, installed = False):
        self.name = name
        self.section = section
        self.version = version
        self.description = description
        self.vote = vote
        self.obsolete = obsolete
        self.installed = installed

    def __str__(self):
        out = "%s/%s %s" % (self.section, self.name, self.version)
        if self.installed:
            out += " [installed]"
        if self.obsolete:
            out += " (Out of Date)"
        if self.vote is not None:
            out += " (%d)" % self.vote
        for line in self.description:
            out += "\n\t%s" % line
        return out


    def __cmp__(self, other):
        if self.obsolete and not other.obsolete:
            return 1
        elif not self.obsolete and other.obsolete:
            return -1
        elif self.vote is None and other.vote is None:
            return cmp(self.name, other.name)
        elif other.vote is None:
            return -1
        elif self.vote is None:
            return 1
        else:
            cmpval = cmp(other.vote, self.vote)
            if cmpval != 0:
                return cmpval
            else:
                return cmp(self.name, other.name)


def main():
    parser = argparse.ArgumentParser()
    aur = parser.add_mutually_exclusive_group()
    obsolete = parser.add_mutually_exclusive_group()
    vote = parser.add_mutually_exclusive_group()
    aur.add_argument("-a", "--aur", action='store_true', default=True)
    aur.add_argument("-A", "--no-aur", action='store_true', default=False)
    obsolete.add_argument("-o", "--obsolete", action='store_true', default=False)
    obsolete.add_argument("-O", "--no-obsolete", action='store_true', default=True)
    vote.add_argument("-v", "--vote", action='store_true', default=True)
    vote.add_argument("-V", "--no-vote", action='store_true', default=False)
    parser.add_argument("searchterm")

    args = parser.parse_args()

    if args.no_aur:
        flags = "-Ss"
    else:
        flags = "-Ssa"

    output = Popen(["yaourt", flags, args.searchterm], stdout=PIPE).communicate()[0]

    sections = {}

    i = 0
    target = None
    description = []
    expsrc = r"^" + r"(?P<section>\S+)" + r"/" + 
        r"(?P<name>\S+)" + r"\s*" +
        r"(?P<version>\S+)" + r"\s*" +
        r"(?P<group>\([^)]+\))?" + r"\s*" +
        r"(?P<installed>\[installed\])?" + r"\s*" +
        r"(?P<obsolete>\(Out of Date\))?" + r"\s*" +
        r"(?P<vote>\(\d+\))?" + r"$"
    linexp = re.compile(expsrc)
    for line in output.splitlines():
        matches = lineexp.match(line)
        if matches:
            groups = list(matches.groups())
            if target is not None:
                target.description = description
                description = []
                if target.section not in sections:
                    sections[target.section] = []
                sections[target.section].append(target)
            target = Target(groups[1], groups[0], groups[2])
            for j in range(3, len(groups)):
                if groups[j] == "[installed]":
                    target.installed = True
                elif groups[j] == "(Out of Date)":
                    target.obsolete = True
                elif groups[j] is not None:
                    target.vote = int(groups[j])
        else:
            description.append(line.strip())

    for (section, targets) in sections.iteritems():
        if section != 'aur':
            if not args.no_vote:
                targets.sort()
            for target in targets:
                if args.obsolete or not target.obsolete:
                    print str(target)
    if 'aur' in sections:
        targets = sections['aur']
        if not args.no_vote:
            targets.sort()
        for target in targets:
            if args.obsolete or not target.obsolete:
                print str(target)

if __name__ == "__main__":
    main()
