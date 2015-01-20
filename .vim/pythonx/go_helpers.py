# coding=utf8

import vim
import re
import os

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

def _go_get_buffer_before_cursor():
    cursor = vim.current.window.cursor
    line_number = cursor[0]
    buffer = vim.current.buffer

    return '\n'.join(buffer[:line_number-1])
