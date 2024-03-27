document.addEventListener('DOMContentLoaded', function () {
    fetchProducts();
});

var productList = [];


document.getElementById("productForm").addEventListener("submit", function(event) {
    event.preventDefault();

    // Get input values
    var productId = document.getElementById("productId").value;
    var productName = document.getElementById("productName").value;
    var productQuantity = parseFloat(document.getElementById("productQuantity").value);
    var productPrice = parseFloat(document.getElementById("productPrice").value);
    var productwprice = parseFloat(document.getElementById("productwprice").value); // Added
    var discount = parseFloat(document.getElementById("discount").value); // Added


    // Check if the product already exists in the productList array
    var existingProductIndex = productList.findIndex(product => product.product_id === productId);

    if (existingProductIndex !== -1) {
        // If the product exists, update its quantity
        productList[existingProductIndex].quantity += productQuantity;
    } else {
        // If the product doesn't exist, add it to the productList array
        var productIndex = products.findIndex(product => product.product_id === productId);
        if (productIndex !== -1) {
            // Subtract the purchased quantity from the product quantity in the products array
            var remainingQuantity = products[productIndex].quantity - productQuantity;
            if(products[productIndex].quantity < productQuantity){
                alert("Entered quantity exceeds available quantity for product: " + productName);
                return; // Exit the function to prevent further processing

            }
            if (remainingQuantity >= 0) {
                productList.push({
                    product_id: productId,
                    quantity: remainingQuantity
                });
                // Update the remaining quantity in the products array
                products[productIndex].quantity = remainingQuantity;
            } else {
                // Handle insufficient quantity error
                console.error("Insufficient quantity for product: " + products[productIndex].product_name);
            }
        } else {
            // Handle product not found error
            console.error("Product not found in the products array");
        }
    }




    // Calculate total discount for this product
    var sum = productQuantity * productPrice;
    var totalDiscount = (discount*sum)/100;



    // Calculate total cost for this product
    var productTotal = sum - totalDiscount;
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
        <span>Quantity: ${productQuantity}&nbsp;&nbsp;Price: ₹${productPrice.toFixed(2)}&nbsp;&nbsp;Discount: ${discount.toFixed(2)}%&nbsp;&nbsp;Total: ₹${productTotal.toFixed(2)}</span>
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

        // Update productList array
        var existingProductIndex = productList.findIndex(product => product.product_id === productId);
        if (existingProductIndex !== -1) {
            // Reduce the quantity of the product in the productList array
            productList[existingProductIndex].quantity -= productQuantity;
            if (productList[existingProductIndex].quantity <= 0) {
                // If the quantity becomes zero or negative, remove the product from the array
                productList.splice(existingProductIndex, 1);
            }
        }
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

    // Clear input fields
    document.getElementById("productId").value = "";
    document.getElementById("productName").value = "";
    document.getElementById("productQuantity").value = "";
    document.getElementById("productPrice").value = "";
    document.getElementById("productwprice").value = "";
    console.log(productList)

});

var totalwprice = 0;

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


productNameInput.addEventListener('input', () => {
    const searchKeyword = productNameInput.value.trim().toLowerCase();
    const matchedProducts = products.filter(product => {
        // Filter out products with zero or negative quantity
        return product.product_name.toLowerCase().includes(searchKeyword) && product.quantity > 0;
    });
    
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

    }
    productDropdown.classList.add('hidden');
});

document.addEventListener('click', (event) => {
    if (!productDropdown.contains(event.target) && event.target !== productNameInput) {
        productDropdown.classList.add('hidden');
    }
});

document.getElementById("confirmOrderButton").addEventListener("click", function() {
    var totalBillElement = document.getElementById("totalBill");
    if (!totalBillElement) {
        console.log("Error: Total bill element not found.");
        return;
    }

    var totalBill = totalBillElement.textContent;
    console.log(totalBill);

      // Assuming you have an endpoint to handle the order confirmation
      var orderData = {
          totalBill: totalBill,
          totalwprice: totalwprice,
          productList: productList

          // Add other order data as needed
      };

      fetch('/submit_order', {
      method: 'POST',
      headers: {
          'Content-Type': 'application/json'
      },
      body: JSON.stringify(orderData)
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
  productListItems.innerHTML = '';
  totalBillElement.innerHTML = '0.00'

  });


  document.getElementById("openModalBtn").addEventListener("click", function() {
    // Make an AJAX request to fetch notifications
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "/fetch_notifications", true); // Adjust the URL to match your Flask route
    xhr.onreadystatechange = function() {
        if (xhr.readyState == 4 && xhr.status == 200) {
            var response = JSON.parse(xhr.responseText);
            if (response.success) {
                var notifications = response.notifications;
                // Display notifications in the modal
                var notificationList = document.getElementById("notificationList");
                notificationList.innerHTML = ''; // Clear previous notifications
                if (!notifications || notifications.length === 0) {
                    // Create a notification item for empty notifications
                    var notificationItem = document.createElement("div");
                    notificationItem.classList.add("notification-item");
                    
                    var p = document.createElement("p");
                    p.textContent = 'Nothing to display here!!'; // Display message for empty notifications
                    notificationItem.appendChild(p);
                    notificationList.appendChild(notificationItem);
                } else {
                notifications.forEach(function(notification) {
                    var notificationItem = document.createElement("div");
                    notificationItem.classList.add("notification-item");
                    
                    var p = document.createElement("p");
                    p.textContent = notification.message;
                    // Apply styling for urgent notifications
                    p.style.color = 'red';
                    p.style.fontWeight = 'bold';
                    p.style.padding = '10px';
                    p.style.marginBottom = '10px';
                    p.style.backgroundColor = '#1F2937'; // Background color
                    p.style.borderRadius = '5px'; // Rounded corners
                    notificationItem.appendChild(p);

                    // Create delete button
                    var deleteButton = document.createElement("button");
                    deleteButton.textContent = "Delete";
                    deleteButton.classList.add("delete-btn");
                    deleteButton.addEventListener("click", function() {
                        // Send delete request to backend
                        var deleteXhr = new XMLHttpRequest();
                        deleteXhr.open("DELETE", "/delete_notification", true); // Adjust the URL to match your Flask route
                        deleteXhr.setRequestHeader("Content-Type", "application/json");
                        deleteXhr.onreadystatechange = function() {
                            if (deleteXhr.readyState == 4) {
                                if (deleteXhr.status == 200) {
                                    var deleteResponse = JSON.parse(deleteXhr.responseText);
                                    if (deleteResponse.success) {
                                        // Remove notification from UI
                                        notificationList.removeChild(notificationItem);
                                    } else {
                                        console.error("Error deleting notification:", deleteResponse.error);
                                    }
                                } else {
                                    console.error("Error deleting notification: Server returned status", deleteXhr.status);
                                }
                            }
                        };
                        deleteXhr.send(JSON.stringify({ id: notification.product_id })); // Assuming notification has an 'id' property
                    });
                    

                    notificationItem.appendChild(deleteButton);
                    notificationList.appendChild(notificationItem);
                });
            }
                // Show the modal
                document.getElementById("myModal").style.display = "block";
            } else {
                console.error("Error fetching notifications:", response.error);
            }
        }
    };
    xhr.send();
});

