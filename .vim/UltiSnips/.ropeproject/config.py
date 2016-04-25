def set_prefs(prefs):
    """This function is called before opening the project"""
    prefs['ignored_resources'] = ['*.pyc', '*~', '.ropeproject', '.git']

    prefs.add('python_path', '~/.vim/bundle/vim-pythonx/pythonx')

    # Should rope save object information or not.
    prefs['save_objectdb'] = True
    prefs['compress_objectdb'] = False

    # If `True`, rope analyzes each module when it is being saved.
    prefs['automatic_soa'] = True
    # The depth of calls to follow in static object analysis
    prefs['soa_followed_calls'] = 0

    # If `False` when running modules or unit tests "dynamic object
    # analysis" is turned off.  This makes them much faster.
    prefs['perform_doa'] = True

    # Rope can check the validity of its object DB when running.
    prefs['validate_objectdb'] = True

    # How many undos to hold?
    prefs['max_history_items'] = 32

    # Shows whether to save history across sessions.
    prefs['save_history'] = True
    prefs['compress_history'] = False

    # Set the number spaces used for indenting.  According to
    # :PEP:`8`, it is best to use 4 spaces.  Since most of rope's
    # unit-tests use 4 spaces it is more reliable, too.
    prefs['indent_size'] = 4

    # Builtin and c-extension modules that are allowed to be imported
    # and inspected by rope.
    prefs['extension_modules'] = []

    # Add all standard c-extensions to extension_modules list.
    prefs['import_dynload_stdmods'] = True

    # If `True` modules with syntax errors are considered to be empty.
    # The default value is `False`; When `False` syntax errors raise
    # `rope.base.exceptions.ModuleSyntaxError` exception.
    prefs['ignore_syntax_errors'] = False

    # If `True`, rope ignores unresolvable imports.  Otherwise, they
    # appear in the importing namespace.
    prefs['ignore_bad_imports'] = False


def project_opened(project):
    """This function is called after opening the project"""
    # Do whatever you like here!
