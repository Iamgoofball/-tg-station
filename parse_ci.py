import json

with open(r'C:\Users\jaisw\.local\share\opencode\tool-output\tool_f83ba4e11001ytLfSvUY781vRj', encoding='utf-8') as f:
    data = json.load(f)

# Find linter check run
for run in data.get('check_runs', []):
    name = run['name']
    conclusion = run.get('conclusion', 'in_progress')
    annotations_url = run['output'].get('annotations_url', '')
    annotations_count = run['output'].get('annotations_count', 0)
    
    if 'linters' in name.lower() or 'linter' in name.lower():
        print(f"LINTER CHECK:")
        print(f"  Name: {name}")
        print(f"  Conclusion: {conclusion}")
        print(f"  Annotations: {annotations_count}")
        print(f"  Annotations URL: {annotations_url}")
        print(f"  HTML URL: {run.get('html_url', 'N/A')}")
        print()

# Also show a sample integration test failure
for run in data.get('check_runs', []):
    if run['output'].get('annotations_count', 0) > 0 and run.get('conclusion') == 'failure':
        print(f"FAILED CHECK: {run['name']}")
        print(f"  Annotations URL: {run['output']['annotations_url']}")
        print(f"  HTML URL: {run.get('html_url', 'N/A')}")
        print()
