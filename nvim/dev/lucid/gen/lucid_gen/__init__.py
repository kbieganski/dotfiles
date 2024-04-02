from jinja2 import Template
from argparse import ArgumentParser
import os

green = '#44ff88'
red = '#ff5577'
blue = '#00aaff'
yellow = '#ffcc00'


class Scale:
    def __getitem__(self, x):
        x = min(1, max(0, x))
        return f'#{int(x * 255):02x}{int(x * 255):02x}{int(x * 255):02x}'


templates = {}
for name in ['nvim']:
    with open(f'{os.path.dirname(__file__)}/{name}.lua.jinja') as file:
        templates[name] = Template(file.read())

def main():
    arg_parser = ArgumentParser(description='Generate the Lucid color scheme')
    arg_parser.add_argument('neovim', action='store_true', help='Generate for Neovim')
    args = arg_parser.parse_args()
    if args.neovim:
        print(templates['nvim'].render(scale=Scale()))
