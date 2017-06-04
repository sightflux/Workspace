#! /usr/bin/env python
import os
import argparse
import subprocess

class DockerCommand:
    def __init__(self, parser, docker_image='gcc'):
        self.args, self.options = parser.parse_known_args()
        self.options = ' '.join(self.options)

        self.command = 'docker run --rm -v {host_dir}:{container_dir} -w {container_dir}'.format(
            host_dir=self.args.host_dir, container_dir=self.args.container_dir
        )

        self.docker_image = docker_image

        if self.args.interactive:
            self.command = '{} -it'.format(self.command)

    def format_build(self):
        command = '{command} {docker_image} g++ -lpthread {options}'.format(
            command=self.command, docker_image=self.docker_image,
            options=self.options)
        return command

    def format_run(self):
        command = '{command} {docker_image} {target}'.format(
            command=self.command, docker_image=self.docker_image, target=self.args.bin)
        return command

    def run(self):
        command = self.args.command
        if command.lower() == 'build':
            command_str = self.format_build()
        elif command.lower() == 'run':
            command_str = self.format_run()
        else:
            raise ValueError('{} is not a valid command')

        result = subprocess.run(command_str.split())
        result.check_returncode()

def main():
    parser = setup_parser()
    docker_command = DockerCommand(parser)
    docker_command.run()

def setup_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument('--host', dest='host_dir', default=os.getcwd())
    parser.add_argument('--container', dest='container_dir', default='/usr/src/app')
    parser.add_argument('--image', default='gcc')
    parser.add_argument('-i', dest='interactive', action='store_true')

    subparsers = parser.add_subparsers(dest='command')
    parser_build = subparsers.add_parser('build')

    parser_run = subparsers.add_parser('run')
    parser_run.add_argument('bin')
    return parser

if __name__ == '__main__':
    main()
