// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFacet {
    function foo() external view returns (string memory);
    function bar() external view returns (string memory);
}

contract FacetA is IFacet {
    function foo() external pure override returns (string memory) {
        return "Function A - foo()";
    }

    function bar() external pure override returns (string memory) {
        return "Function A - bar()";
    }
}

contract FacetB is IFacet {
    function foo() external pure override returns (string memory) {
        return "Function B - foo()";
    }

    function bar() external pure override returns (string memory) {
        return "Function B - bar()";
    }
}