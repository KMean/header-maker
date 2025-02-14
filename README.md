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

### Via npm (Recommended)

Header Maker is available as an npm package. To install it globally, run:

```bash
npm install -g header-maker
```
## Manual Installation from GitHub
Clone the repository and make the script executable:

```bash
git clone https://github.com/KMean/header-maker.git
cd header-maker
chmod +x bin/header.sh
```
Then run the script directly:

```bash
./bin/header.sh --py "My Header Title"
```
## Installation via install.sh Script
You can also install Header Maker into /usr/local/bin using the provided install.sh script:

```bash
curl -o install.sh https://raw.githubusercontent.com/KMean/header-maker/main/install.sh
chmod +x install.sh
sudo ./install.sh
```
This downloads the header script and places it as header in /usr/local/bin, allowing you to run:

```bash
header --py "My Header Title"
```
Note: Installing to /usr/local/bin requires sudo privileges.

## Usage
Run the script with your desired options. Here are a few examples:

## Basic Usage
Generate a simple Python header with a centered title:

```bash
header --sol "My Header Title"
```
Example Output:
```bash
//----------------------------------------------------------------------//
//                           My Header Title                            //
//----------------------------------------------------------------------//
```
Advanced Usage
Generate a Python header with a timestamp in the border, right-aligned title, dynamic template, and a footer:

```bash
header --sol --timestamp --template "Author: \$USER, Date: \$(date '+%Y-%m-%d')" --footer "END OF SCRIPT" "Custom Header Title" "Additional Info"
```

Example Output:

```bash
//------------------------ 2025-02-14 19:51:19 -------------------------//
//                         Custom Header Title                          //
//                           Additional Info                            //
//                   Author: kmean, Date: 2025-02-14                    //
//------------------------ 2025-02-14 19:51:19 -------------------------//

//----------------------------------------------------------------------//
//                            END OF SCRIPT                             //
//----------------------------------------------------------------------//
```
## Custom Border Example
Generate a JavaScript header with a custom border character (#):

```bash
header --sol --char "%" "My Header Title"
```
Example Output:

```bash
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                           My Header Title                            //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
```
## Contributing
Contributions are welcome! Feel free to fork the repository, open issues, and submit pull requests for improvements or additional features.
