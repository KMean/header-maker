# Header Maker
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/release/KMean/header-maker.svg)](https://github.com/KMean/header-maker/releases)
[![Build Status](https://img.shields.io/github/workflow/status/KMean/header-maker/CI)](https://github.com/KMean/header-maker/actions)

Header Maker is a versatile header generation tool for your source code files. It supports multiple languages and provides customizable options like timestamps, footers, custom alignment, multiline titles, and dynamic templates to make your code headers both informative and consistent.

## Features

- **Multi-Language Support:**  
  Generate headers for Python, SQL, HTML, JavaScript, C, Java, Shell, CSS, PHP, Go, Rust, Lua, Solidity, and more.

- **Custom Border:**  
  Specify any character for your header's border using the `--char` option.

- **Timestamp Integration:**  
  Automatically include the current date and time in the header borders with the `--timestamp` flag.

- **Footer Block:**  
  Append a footer to your header using the `--footer` option for additional notes or end-of-script markers.

- **Custom Alignment:**  
  Align your header text to the left, center, or right with the `--align` option.

- **Multiline Titles:**  
  Provide multiple title lines—each non-flag argument is treated as a separate line in your header.

- **Template Support:**  
  Dynamically insert shell variables and command outputs (e.g., user name, date) into your header using the `--template` option.

## Installation

Clone the repository and make the script executable:

```bash
git clone https://github.com/yourusername/header-maker.git
cd header-maker
chmod +x header.sh
```

## Usage
Run the script with your desired options. Here are a few examples:

```bash
./header.sh --py "My Header Title"
```

## Advanced Usage
Generate a Python header with a timestamp in the border, right-aligned title, dynamic template, and a footer:
```bash
./header.sh --py --timestamp --align right --template "Author: \$USER, Date: \$(date '+%Y-%m-%d')" --footer "END OF SCRIPT" "Custom Header Title" "Additional Info"
```
```bash
//---------- 2025-02-14 15:42:10 -----------//
//             Custom Header Title          //
//             Additional Info              //
//  Author: yourusername, Date: 2025-02-14  //
//---------- 2025-02-14 15:42:10 -----------//
```

## Custom Border Example
Generate a JavaScript header with a custom border character (#):

```bash
./header.sh --js --char "#" "JS Header"
```

```bash
//---------- 2025-02-14 15:42:10 -----------//
//             Custom Header Title          //
//             Additional Info              //
//  Author: yourusername, Date: 2025-02-14  //
//---------- 2025-02-14 15:42:10 -----------//
```
```bash
//----------#############################----------//
//                   END OF SCRIPT                 //
//----------#############################----------//
```

## Contributing
Contributions are welcome! Feel free to fork the repository, open issues, and submit pull requests for improvements or additional features.