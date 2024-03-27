const  orderData = [];

document.addEventListener('DOMContentLoaded', function () {
    fetchProducts();
});



document.getElementById("productForm").addEventListener("submit", function(event) {
    event.preventDefault();

    // Get input values
    var productId = document.getElementById("productId").value;
    var productName = document.getElementById("productName").value;
    var productQuantity = parseFloat(document.getElementById("productQuantity").value);
    var productPrice = parseFloat(document.getElementById("productPrice").value);
    var productwprice = parseFloat(document.getElementById("productwprice").value);
    var sid = parseFloat(document.getElementById("sid").value);





    // Calculate total cost for this product
    var productTotal = productQuantity * productwprice;
    var wholesale = productQuantity * productwprice;

    

    // Inside the form submission event listener
    var productListItems = document.getElementById("productListItems");

    var productItem = document.createElement("div");
    productItem.classList.add("flex", "justify-between", "items-center", "py-3", "bg-gray-100", "rounded-md", "mb-2");

    var productInfo = document.createElement("div");
    productInfo.classList.add("text-sm", "text-gray-800");
    productInfo.innerHTML = `
        <span class="mr-2">&nbsp;${productId}</span>
        <span class="mr-2">&nbsp;${productName}&nbsp;&nbsp;</span>
        <span>Quantity: ${productQuantity}&nbsp;&nbsp;Price: ₹${productPrice.toFixed(2)}&nbsp;&nbsp;Total: ₹${productTotal.toFixed(2)}</span>
    `;

    var deleteButton = document.createElement("button");
    deleteButton.innerHTML = "Delete";
    deleteButton.classList.add("text-red-600", "mr-5", "font-semibold", "focus:outline-none");
    deleteButton.addEventListener("click", function() {
        productListItems.removeChild(productItem); // Remove the product item
        // Update total bill amount after removing the product
        var totalBillElement = document.getElementById("totalBill");
        var currentTotalBill = parseFloat(totalBillElement.textContent);
        var newTotalBill = currentTotalBill - productTotal;
        totalBillElement.textContent = newTotalBill.toFixed(2);

        totalwprice -= wholesale;

    });

    productItem.appendChild(productInfo);
    productItem.appendChild(deleteButton);
    productListItems.appendChild(productItem);

    // Update total bill amount
    var totalBillElement = document.getElementById("totalBill");
    var currentTotalBill = parseFloat(totalBillElement.textContent);
    var newTotalBill = currentTotalBill + productTotal;
    totalBillElement.textContent = newTotalBill.toFixed(2);

    totalwprice += wholesale; 


    var totalBill = totalBillElement.textContent;
    var product_id = document.getElementById("productId").value;
    var productName = document.getElementById("productName").value;
    var productPrice = document.getElementById("productPrice").value;
    var productQuantity = document.getElementById("productQuantity").value;
    var sid = document.getElementById("sid").value;
    var productwprice = document.getElementById("productwprice").value;

    // Find the product in the products array
    var productIndex = products.findIndex(product => product.product_id === product_id);
    if (productIndex !== -1) {
        // Add the purchased quantity to the current product quantity
        var currentQuantity = products[productIndex].quantity;
        var updatedQuantity = currentQuantity + parseInt(productQuantity); // Convert productQuantity to an integer before adding
    } else {
        // Handle product not found error
        console.error("Product not found in the products array");
        return; // Exit the function or perform necessary action
    }

    orderData.push({
        totalBill: totalBill,
        product_id: product_id,
        productName: productName,
        productPrice: productPrice,
        productQuantity: updatedQuantity,
        sid: sid,
        productwprice: productwprice
    });

    localStorage.setItem('orderData', JSON.stringify(orderData));
    console.log(orderData)

    // Clear input fields
    document.getElementById("productId").value = "";
    document.getElementById("productName").value = "";
    document.getElementById("productQuantity").value = "";
    document.getElementById("productPrice").value = "";
    document.getElementById("productwprice").value = "";
    document.getElementById("sid").value = "";


});

var totalwprice = 0;



document.getElementById("confirmOrderButton").addEventListener("click", function() {
    // Get order data from localStorage
    let orderData = JSON.parse(localStorage.getItem('orderData')) || [];

    // Prepare form data
    const formData = new FormData();
    formData.append('orderData', JSON.stringify(orderData));
    formData.append('totalwprice', totalwprice);
    formData.append('total_amount', totalBill);

    // Send POST request to Flask backend
    fetch('/update_order', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        console.log(data);
        if (data.success) {
            alert(data.message);
            // Redirect or perform other actions after successful order submission
        } else {
            alert(data.message);
        }
    })
    .then(data => {
        console.log('Success:', data);
        // Handle success response as needed
    })
    .catch(error => {
        console.error('Error:', error);
        // Handle error as needed
    });
    var totalBillElement = document.getElementById("totalBill");

    productListItems.innerHTML = '';
    totalBillElement.innerHTML = '0.00'


});

let products = []; // Array to store product names

function fetchProducts() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', '/get_products', true);  // Update the URL to match your Flask route
    xhr.onload = function() {
        if (xhr.status == 200) {
            // Parse the JSON response
            var response = JSON.parse(xhr.responseText);
            
            // Check if the response contains the "products" array
            if (response.products) {
                // Store the product details array in the variable "products"
                products = response.products;
                
                // Now you can use the "products" array as needed
                console.log("Product Details:", products);
            } else {
                console.error('Error: Products array not found in the response');
            }
        } else {
            console.error('Error fetching product details: ' + xhr.status);
        }
    };
    xhr.send();
}
const productNameInput = document.getElementById('productName');
const productIdInput = document.getElementById('productId');
const productQuantityInput = document.getElementById('productQuantity');
const productPriceInput = document.getElementById('productPrice');
const productDropdown = document.getElementById('productDropdown');
const productwprice = document.getElementById('productwprice');
const sid = document.getElementById('sid');



productNameInput.addEventListener('input', () => {
    const searchKeyword = productNameInput.value.trim().toLowerCase();
    const matchedProducts = products.filter(product => product.product_name.toLowerCase().includes(searchKeyword));
    
    if (matchedProducts.length > 0) {
        const dropdownContent = matchedProducts.map(product => `<div class="p-2 product-item">${product.product_name}</div>`).join('');
        productDropdown.innerHTML = dropdownContent;
        productDropdown.classList.remove('hidden');
    } else {
        productDropdown.innerHTML = '';
        productDropdown.classList.add('hidden');
    }
});

productDropdown.addEventListener('click', (event) => {
    const selectedProductName = event.target.textContent;
    const selectedProduct = products.find(product => product.product_name === selectedProductName);
    if (selectedProduct) {
        productIdInput.value = selectedProduct.product_id;
        productNameInput.value = selectedProduct.product_name;
        productQuantityInput.value = ''; // Clear previous value
        productPriceInput.value = selectedProduct.MRP;
        productwprice.value = selectedProduct.wprice;
        sid.value = selectedProduct.suplier_id;


    }
    productDropdown.classList.add('hidden');
});

document.addEventListener('click', (event) => {
    if (!productDropdown.contains(event.target) && event.target !== productNameInput) {
        productDropdown.classList.add('hidden');
    }
});

