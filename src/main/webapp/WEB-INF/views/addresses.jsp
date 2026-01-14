<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Addresses - Kharid-daari</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .profile-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 2rem;
        }
        .profile-tabs {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            border-bottom: 2px solid #eee;
        }
        .profile-tab {
            padding: 1rem 2rem;
            background: none;
            border: none;
            border-bottom: 3px solid transparent;
            cursor: pointer;
            font-size: 1.1rem;
            font-weight: 600;
            color: #666;
            transition: all 0.3s;
        }
        .profile-tab.active {
            color: #667eea;
            border-bottom-color: #667eea;
        }
        .profile-tab:hover {
            color: #667eea;
        }
        .address-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }
        .address-card {
            background: white;
            padding: 1.5rem;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            position: relative;
        }
        .address-card.default {
            border: 3px solid #667eea;
        }
        .default-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: #667eea;
            color: white;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .address-content {
            margin-bottom: 1rem;
            line-height: 1.8;
        }
        .address-actions {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }
        .add-address-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem 2rem;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            cursor: pointer;
            margin-bottom: 2rem;
        }
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
        }
        .modal-content {
            background: white;
            margin: 2rem auto;
            padding: 2rem;
            border-radius: 10px;
            max-width: 600px;
            max-height: 90vh;
            overflow-y: auto;
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        .close-modal {
            font-size: 2rem;
            cursor: pointer;
            color: #999;
        }
        .form-group {
            margin-bottom: 1.5rem;
        }
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #333;
        }
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 0.8rem;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
        }
        .form-group small {
            color: #666;
            font-size: 0.85rem;
        }
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .checkbox-group input[type="checkbox"] {
            width: auto;
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <div class="profile-container">
        <h2>My Profile</h2>

        <c:if test="${not empty success}">
            <div class="alert alert-success" style="background: #d4edda; color: #155724; padding: 1rem; border-radius: 5px; margin-bottom: 1rem;">
                ${success}
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-error" style="background: #f8d7da; color: #721c24; padding: 1rem; border-radius: 5px; margin-bottom: 1rem;">
                ${error}
            </div>
        </c:if>

        <div class="profile-tabs">
            <button class="profile-tab" onclick="window.location.href='${pageContext.request.contextPath}/profile#details'">Profile Details</button>
            <button class="profile-tab" onclick="window.location.href='${pageContext.request.contextPath}/profile#edit'">Edit Profile</button>
            <button class="profile-tab" onclick="window.location.href='${pageContext.request.contextPath}/profile#password'">Change Password</button>
            <button class="profile-tab active">Addresses</button>
            <button class="profile-tab" onclick="window.location.href='${pageContext.request.contextPath}/profile/orders'">Order History</button>
        </div>

        <button class="add-address-btn" onclick="showAddModal()">+ Add New Address</button>

        <div class="address-list">
            <c:forEach var="address" items="${addresses}">
                <div class="address-card ${address['default'] ? 'default' : ''}">
                    <c:if test="${address['default']}">
                        <span class="default-badge">Default</span>
                    </c:if>
                    
                    <div class="address-content">
                        <div><strong>${address.line1}</strong></div>
                        <c:if test="${not empty address.line2}">
                            <div>${address.line2}</div>
                        </c:if>
                        <div>${address.city}<c:if test="${not empty address.state}">, ${address.state}</c:if></div>
                        <c:if test="${not empty address.postalCode}">
                            <div>${address.postalCode}</div>
                        </c:if>
                        <div><strong>${address.country}</strong></div>
                    </div>

                    <div class="address-actions">
                        <button class="btn btn-outline" style="padding: 0.5rem 1rem;" onclick="editAddress(${address.id}, '${address.line1}', '${address.line2}', '${address.city}', '${address.state}', '${address.postalCode}', '${address.country}', ${address['default']})">Edit</button>
                        <c:if test="${!address['default']}">
                            <form action="${pageContext.request.contextPath}/profile/address/set-default" method="post" style="display: inline;">
                                <input type="hidden" name="id" value="${address.id}">
                                <button type="submit" class="btn btn-outline" style="padding: 0.5rem 1rem;">Set Default</button>
                            </form>
                        </c:if>
                        <form action="${pageContext.request.contextPath}/profile/address/delete" method="post" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this address?')">
                            <input type="hidden" name="id" value="${address.id}">
                            <button type="submit" class="btn btn-primary" style="padding: 0.5rem 1rem; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">Delete</button>
                        </form>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty addresses}">
                <div style="grid-column: 1 / -1; text-align: center; padding: 3rem;">
                    <p style="color: #999; font-size: 1.2rem;">No addresses added yet. Click "Add New Address" to get started.</p>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Add Address Modal -->
    <div id="addModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Add New Address</h3>
                <span class="close-modal" onclick="closeAddModal()">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/profile/address/add" method="post" onsubmit="return validateAddress()">
                <div class="form-group">
                    <label for="line1">Address Line 1 *</label>
                    <input type="text" id="line1" name="line1" required maxlength="255">
                    <small>Street address, P.O. box, company name, c/o</small>
                </div>

                <div class="form-group">
                    <label for="line2">Address Line 2</label>
                    <input type="text" id="line2" name="line2" maxlength="255">
                    <small>Apartment, suite, unit, building, floor, etc. (optional)</small>
                </div>

                <div class="form-group">
                    <label for="city">City *</label>
                    <input type="text" id="city" name="city" required maxlength="100">
                </div>

                <div class="form-group">
                    <label for="state">State/Province</label>
                    <input type="text" id="state" name="state" maxlength="100">
                    <small>Optional</small>
                </div>

                <div class="form-group">
                    <label for="postalCode">Postal Code</label>
                    <input type="text" id="postalCode" name="postalCode" maxlength="20">
                    <small>ZIP/Postal code (optional)</small>
                </div>

                <div class="form-group">
                    <label for="country">Country *</label>
                    <input type="text" id="country" name="country" required maxlength="100">
                </div>

                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" id="isDefault" name="isDefault" value="true">
                        <label for="isDefault" style="margin: 0;">Set as default address</label>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-block">Add Address</button>
            </form>
        </div>
    </div>

    <!-- Edit Address Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Edit Address</h3>
                <span class="close-modal" onclick="closeEditModal()">&times;</span>
            </div>
            <form action="${pageContext.request.contextPath}/profile/address/update" method="post" onsubmit="return validateEditAddress()">
                <input type="hidden" id="editId" name="id">
                
                <div class="form-group">
                    <label for="editLine1">Address Line 1 *</label>
                    <input type="text" id="editLine1" name="line1" required maxlength="255">
                </div>

                <div class="form-group">
                    <label for="editLine2">Address Line 2</label>
                    <input type="text" id="editLine2" name="line2" maxlength="255">
                </div>

                <div class="form-group">
                    <label for="editCity">City *</label>
                    <input type="text" id="editCity" name="city" required maxlength="100">
                </div>

                <div class="form-group">
                    <label for="editState">State/Province</label>
                    <input type="text" id="editState" name="state" maxlength="100">
                </div>

                <div class="form-group">
                    <label for="editPostalCode">Postal Code</label>
                    <input type="text" id="editPostalCode" name="postalCode" maxlength="20">
                </div>

                <div class="form-group">
                    <label for="editCountry">Country *</label>
                    <input type="text" id="editCountry" name="country" required maxlength="100">
                </div>

                <div class="form-group">
                    <div class="checkbox-group">
                        <input type="checkbox" id="editIsDefault" name="isDefault" value="true">
                        <label for="editIsDefault" style="margin: 0;">Set as default address</label>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-block">Update Address</button>
            </form>
        </div>
    </div>

    <script>
        function showAddModal() {
            document.getElementById('addModal').style.display = 'block';
        }

        function closeAddModal() {
            document.getElementById('addModal').style.display = 'none';
        }

        function editAddress(id, line1, line2, city, state, postalCode, country, isDefault) {
            document.getElementById('editId').value = id;
            document.getElementById('editLine1').value = line1;
            document.getElementById('editLine2').value = line2 || '';
            document.getElementById('editCity').value = city;
            document.getElementById('editState').value = state || '';
            document.getElementById('editPostalCode').value = postalCode || '';
            document.getElementById('editCountry').value = country;
            document.getElementById('editIsDefault').checked = isDefault;
            document.getElementById('editModal').style.display = 'block';
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        function validateAddress() {
            const line1 = document.getElementById('line1').value.trim();
            const city = document.getElementById('city').value.trim();
            const country = document.getElementById('country').value.trim();

            if (!line1 || !city || !country) {
                alert('Please fill in all required fields (Address Line 1, City, and Country)');
                return false;
            }

            return true;
        }

        function validateEditAddress() {
            const line1 = document.getElementById('editLine1').value.trim();
            const city = document.getElementById('editCity').value.trim();
            const country = document.getElementById('editCountry').value.trim();

            if (!line1 || !city || !country) {
                alert('Please fill in all required fields (Address Line 1, City, and Country)');
                return false;
            }

            return true;
        }

        // Close modal when clicking outside of it
        window.onclick = function(event) {
            const addModal = document.getElementById('addModal');
            const editModal = document.getElementById('editModal');
            if (event.target == addModal) {
                closeAddModal();
            }
            if (event.target == editModal) {
                closeEditModal();
            }
        }
    </script>

    <jsp:include page="includes/footer.jsp" />
</body>
</html>
