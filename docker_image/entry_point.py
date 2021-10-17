import json
val = {"company": "zoominfo", "location": "chennai"}

def main(value):
  return json.dumps(value)

if __name__ == "__main__":
  print(main(val))
