import re
import os

def remove_u_from_codebase(root_dir):
    """
    Replace all occurrences of 'U', 'u' in function names, user-facing strings, and tooling.
    Note: This modifies source files. Use with caution.
    """
    for dirpath, dirnames, filenames in os.walk(root_dir):
        for filename in filenames:
            if filename.endswith(('.py', '.dmm', '.txt', '.json', '.md')):
                filepath = os.path.join(dirpath, filename)
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                # Replace 'U' with 'V' (to avoid collision with 'V' which may be used)
                # Replace 'u' with 'v'
                new_content = content.replace('U', 'V').replace('u', 'v')
                if new_content != content:
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(new_content)
                    print(f"Modified: {filepath}")

if __name__ == '__main__':
    remove_u_from_codebase('.')