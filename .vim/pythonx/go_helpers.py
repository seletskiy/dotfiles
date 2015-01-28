# coding=utf8

import vim
import re
import os
import subprocess
import glob

GOROOT = subprocess.check_output(['go', 'env', 'GOROOT'])

GO_SYNTAX_ITEMS = [
    'String',
    'Keyword',
    'Repeat',
    'Conditional',
    'Number',
    'Statement',
    'Type',
]

# Try to extract type which was used for define previous method and binded
# object name.
#
# If method definition was not found, try to find previous type declaration
# and construct that pair from type name
#
# `func (someName SomeDataType)` -> `('someName', 'SomeDataType').
# `type SomeData struct {` -> `('data', 'SomeData').
def go_extract_prev_method_binding_for_cursor():
    search_space = _go_get_buffer_before_cursor()

    def extract_from_type_definition():
        matches = re.findall(r'(?m)^type (\w+) ', search_space)

        if matches != []:
            type_name = matches[-1]
            object_name = re.findall(r'(\w[^A-Z]+)', type_name)[-1].lower()

            return (object_name, type_name)
        else:
            return None

    def extract_from_method_definition():
        matches = re.findall(r'(?m)^func \(([^)]+)\s+([^)]+)\) ', search_space)

        if matches != []:
            return matches[-1]
        else:
            return None

    result = extract_from_method_definition()
    if result is None:
        result = extract_from_type_definition()

    return result

def go_convert_camelcase_to_snakecase(name):
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)

    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()

def go_guess_package_name_from_file_name(path):
    basename = os.path.basename(os.path.dirname(os.path.abspath(path)))

    if re.match(r'^\w+$', basename):
        return basename
    else:
        return 'main'

def go_get_previous_slice_usage():
    search_space = _go_get_buffer_before_cursor()
    matches = re.findall(r'(\w+)\[', search_space)

    if matches:
        return matches[-1]

    return ""

def go_split_parenthesis():
    line_number, column_number = vim.current.window.cursor
    buffer = vim.current.buffer
    line = buffer[line_number-1]
    first_parenthesis = line.find('(')
    last_parenthesis = line.rfind(')')
    indent = len(line) - len(line.lstrip("\t"))

    buffer[line_number:line_number]= [
        "\t" * (indent + 1) + line[first_parenthesis+1:last_parenthesis] + ",",
        "\t" * indent + line[last_parenthesis:],
        "",
    ]

    buffer[line_number-1] = line[:first_parenthesis+1]

def go_get_previous_declared_var():
    search_space = _go_get_buffer_before_cursor()
    matches = re.findall(r'(\w+) :?=', search_space)

    if matches:
        return matches[-1]

    return ""

def go_cycle_by_var_name():
    line_number, column_number = vim.current.window.cursor
    identifier = go_get_identifier_under_cursor()
    new_identifier = go_get_last_used_var(identifier)
    buffer = vim.current.window.buffer
    line = buffer[line_number-1]

    if column_number-len(identifier) >= 0:
        buffer[line_number-1] = line[:column_number-len(identifier)]
    else:
        buffer[line_number-1] = ""

    buffer[line_number-1] += new_identifier + line[column_number:]

    vim.current.window.cursor = (
        line_number,
        column_number-len(identifier)+len(new_identifier)
    )

def go_get_last_used_var(prev_var=''):
    identifiers = go_get_all_last_used_identifiers()

    if prev_var:
        prev_var_match_found = False
    else:
        prev_var_match_found = True

    walked = {}
    for (identifier, line, column) in identifiers:
        syntax_name = _go_get_syntax_name(line, column)

        if (syntax_name in GO_SYNTAX_ITEMS):
            continue

        if identifier in walked:
            continue

        if prev_var_match_found:
            return identifier

        walked[identifier] = True

        if (prev_var == identifier):
            prev_var_match_found = True

# @TODO: move to lib
def _go_get_syntax_name(line, column):
    return vim.eval(
        'synIDattr(synIDtrans(synID({}, {}, 1)), "name")'.format(
            line, column
        )
    )

def go_get_all_last_used_identifiers():
    search_space = _go_get_buffer_before_cursor()
    line_number, _ = vim.current.window.cursor
    identifiers = []

    for line in reversed(search_space.split('\n')):
        line_number -= 1
        matches = re.finditer(r'([\w.]+)(?![\w.]*\()', line)

        if not matches:
            continue

        for match in reversed(list(matches)):
            identifier = match.groups(1)[0]
            identifiers.append((identifier, line_number, match.start(1)+1))

    return identifiers


def go_get_identifier_under_cursor():
    line_number, column_number = vim.current.window.cursor
    line = vim.current.window.buffer[line_number-1][:column_number]
    matches = re.search('([\w.]+)$', line)

    if not matches:
        return ""

    return matches.group(1)

def _go_get_buffer_before_cursor():
    cursor = vim.current.window.cursor
    line_number = cursor[0]
    buffer = vim.current.buffer

    return '\n'.join(buffer[:line_number-1])

def go_get_imports():
    buffer = vim.current.buffer
    reImportLine = r'\s* ((\w+) \s+)? "([^"]+)" \s*'

    matches = re.findall(r"""
        (?sxm)
        import \s* \(?(
            (""" + reImportLine + """)+
        )\)?""", "\n".join(buffer))

    if not matches:
        return []

    matches = re.findall(r"(?sxm)" + reImportLine, matches[0][0])
    if not matches:
        return[]

    result = []
    for match in matches:
        if not match[1]:
            package_name = go_path_to_import_name(match[2])
        else:
            package_name = match[1]
        result.append((package_name, match[2]))

    return result

def go_path_to_import_name(path):
    goroot = os.environ.get(
        'GOROOT',
        GOROOT.strip()
    )

    gopath = os.environ['GOPATH']
    gopath += ":" + goroot

    for lib_path in gopath.split(':'):
        gofiles = glob.glob(os.path.join(lib_path, "src", path, "*.go"))

        if not gofiles:
            continue

        for gofile in gofiles:
            package_name = go_get_package_name_from_file(gofile)

            if package_name:
                return package_name

def go_get_package_name_from_file(path):
    with open(path) as gofile:
        for line in gofile:
            if line.endswith('_test\n'):
                continue
            if line.startswith('package '):
                return line.split(' ')[1].strip()
