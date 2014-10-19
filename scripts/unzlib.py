import zlib
from cStringIO import StringIO
import sys
import argparse


# Command line parser
def parse_cli():
    """Reads sys.argv and returns an options object."""
    parser = argparse.ArgumentParser(description='Decompress zlib archive')
    parser.add_argument("archive", help="Zlib compress data file")
    return parser.parse_args()


def main(args):
    data = []
    try:
        f = open(args.archive, 'rb')
    except IOError:
        sys.exit(1)
    while 1:
        d = f.read(4096)
        if d:
            data.append(d)
        else:
            break
    print StringIO(zlib.decompress(''.join(data))).readlines()


if __name__ == '__main__':
    main(parse_cli())
