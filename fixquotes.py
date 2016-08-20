import io
import json
import os


def process(file):
	print(file)

	with io.open(file, 'r', encoding='utf-8') as f:
		contents = f.read()

	contents = contents.replace('“', '"').replace('”', '"').replace('’', '\'').replace('‘', '\'').replace('…', '...').replace('\xa0', ' ').replace('–', '-')

	with io.open(file, 'w', encoding='utf-8') as f:
		f.write(contents)


def main():
	settings = {}

	with io.open("carmarkov.cfg", 'r') as f:
		settings = json.load(f)

	for f in os.listdir(settings['log_directory']):
		process(os.path.join(settings['log_directory'], f))

if __name__ == '__main__':
	main()
