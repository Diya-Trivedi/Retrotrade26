<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Listing - Retrotrade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        body {
            background: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .page-header {
            background: var(--primary-gradient);
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
            border-radius: 0 0 20px 20px;
        }
        
        .form-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .form-section-title {
            color: #495057;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .form-section-title i {
            color: #667eea;
            margin-right: 10px;
        }
        
        .current-images {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .current-image-item {
            position: relative;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            background: #f8f9fa;
        }
        
        .current-image-item img {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }
        
        .image-actions {
            padding: 10px;
            display: flex;
            gap: 10px;
            justify-content: center;
            background: white;
        }
        
        .image-actions .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
        }
        
        .primary-badge {
            position: absolute;
            top: 10px;
            left: 10px;
            background: var(--primary-gradient);
            color: white;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            z-index: 10;
        }
        
        .upload-area {
            border: 2px dashed #dee2e6;
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            background: #f8f9fa;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 20px;
        }
        
        .upload-area:hover {
            border-color: #667eea;
            background: #f0f2f5;
        }
        
        .upload-area i {
            font-size: 40px;
            color: #667eea;
            margin-bottom: 10px;
        }
        
        .preview-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }
        
        .preview-item {
            position: relative;
            aspect-ratio: 1;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        
        .preview-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .preview-item .remove-preview {
            position: absolute;
            top: 5px;
            right: 5px;
            width: 25px;
            height: 25px;
            background: rgba(220, 53, 69, 0.9);
            color: white;
            border: none;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 12px;
        }
        
        .condition-container {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 10px;
        }
        
        .condition-option {
            flex: 1 0 auto;
            min-width: 100px;
        }
        
        .condition-option input[type="radio"] {
            display: none;
        }
        
        .condition-option label {
            display: block;
            padding: 10px 20px;
            background: #f8f9fa;
            border: 2px solid #dee2e6;
            border-radius: 30px;
            text-align: center;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .condition-option input[type="radio"]:checked + label {
            background: var(--primary-gradient);
            border-color: transparent;
            color: white;
        }
        
        .btn-submit {
            background: var(--primary-gradient);
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102,126,234,0.4);
            color: white;
        }
        
        .btn-cancel {
            background: #6c757d;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-cancel:hover {
            background: #5a6268;
            color: white;
        }
        
        .form-label {
            font-weight: 500;
            color: #495057;
        }
        
        .form-label .required {
            color: #dc3545;
            margin-left: 3px;
        }
        
        .form-control, .form-select {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 10px 15px;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .alert {
            border-radius: 10px;
        }
        
        .image-input {
            display: none;
        }
        
        .status-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .status-PENDING { background: #ffc107; color: #856404; }
        .status-ACTIVE { background: #28a745; color: white; }
        .status-SOLD { background: #17a2b8; color: white; }
        .status-REJECTED { background: #dc3545; color: white; }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <div class="page-header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2><i class="fas fa-edit me-2"></i>Edit Listing</h2>
                    <p class="mb-0 opacity-75">Update your product information - Only fill fields you want to change</p>
                </div>
                <a href="${pageContext.request.contextPath}/listings/my-listings" class="btn-cancel">
                    <i class="fas fa-arrow-left me-2"></i>Back to My Listings
                </a>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <!-- Status Information -->
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>
                    Listing Status: 
                    <span class="status-badge status-${listing.status}">
                        <c:choose>
                            <c:when test="${listing.status == 'PENDING'}">Pending Approval</c:when>
                            <c:when test="${listing.status == 'ACTIVE'}">Active</c:when>
                            <c:when test="${listing.status == 'SOLD'}">Sold</c:when>
                            <c:when test="${listing.status == 'REJECTED'}">Rejected</c:when>
                        </c:choose>
                    </span>
                    <c:if test="${listing.status == 'PENDING'}">
                        <br><small>Your listing will be reviewed by admin after editing.</small>
                    </c:if>
                </div>

                <form action="${pageContext.request.contextPath}/listings/update/${listing.listingId}" 
                      method="post" enctype="multipart/form-data" id="editForm">
                    
                    <div class="form-container">
                        <!-- Basic Information -->
                        <div class="mb-4">
                            <h5 class="form-section-title">
                                <i class="fas fa-info-circle"></i>Basic Information
                            </h5>
                            
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">
                                        Product Name
                                    </label>
                                    <input type="text" class="form-control" name="listingName" 
                                           value="${listing.listingName}" maxlength="100">
                                    <small class="text-muted">Leave empty to keep current: ${listing.listingName}</small>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">Brand</label>
                                    <input type="text" class="form-control" name="brand" 
                                           value="${listing.brand}" maxlength="50">
                                    <small class="text-muted">Leave empty to keep current: ${listing.brand != null ? listing.brand : 'Not set'}</small>
                                </div>
                                
                                <div class="col-12">
                                    <label class="form-label">
                                        Description
                                    </label>
                                    <textarea class="form-control" name="description" 
                                              maxlength="1000" rows="5">${listing.description}</textarea>
                                    <small class="text-muted">Leave empty to keep current description</small>
                                </div>
                            </div>
                        </div>

                        <!-- Category -->
                        <div class="mb-4">
                            <h5 class="form-section-title">
                                <i class="fas fa-tags"></i>Category
                            </h5>
                            
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">
                                        Category
                                    </label>
                                    <select class="form-select" name="categoryId" id="categorySelect">
                                        <option value="">-- Keep Current: ${listing.category.categoryName} --</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.categoryId}" 
                                                    ${listing.category.categoryId == cat.categoryId ? 'selected' : ''}>
                                                ${cat.categoryName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">
                                        Subcategory
                                    </label>
                                    <select class="form-select" name="subCategoryId" id="subCategorySelect">
                                        <option value="">-- Keep Current: ${listing.subCategory.subCategoryName} --</option>
                                        <c:forEach var="subCat" items="${subcategories}">
                                            <option value="${subCat.subCategoryId}" 
                                                    data-category="${subCat.category.categoryId}"
                                                    ${listing.subCategory.subCategoryId == subCat.subCategoryId ? 'selected' : ''}>
                                                ${subCat.subCategoryName} (${subCat.category.categoryName})
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Price & Condition -->
                        <div class="mb-4">
                            <h5 class="form-section-title">
                                <i class="fas fa-rupee-sign"></i>Price & Condition
                            </h5>
                            
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">
                                        Price (₹)
                                    </label>
                                    <input type="number" class="form-control" name="price" 
                                           value="${listing.price}" step="0.01" min="0">
                                    <small class="text-muted">Leave empty to keep current: ₹${listing.price}</small>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">
                                        Location
                                    </label>
                                    <input type="text" class="form-control" name="location" 
                                           value="${listing.location}" maxlength="100">
                                    <small class="text-muted">Leave empty to keep current: ${listing.location != null ? listing.location : 'Not set'}</small>
                                </div>
                                
                                <div class="col-12">
                                    <label class="form-label">
                                        Condition
                                    </label>
                                    <div class="condition-container">
                                        <div class="condition-option">
                                            <input type="radio" name="condition" value="NEW" 
                                                   id="condNew" ${listing.condition == 'NEW' ? 'checked' : ''}>
                                            <label for="condNew">New</label>
                                        </div>
                                        
                                        <div class="condition-option">
                                            <input type="radio" name="condition" value="LIKE_NEW" 
                                                   id="condLikeNew" ${listing.condition == 'LIKE_NEW' ? 'checked' : ''}>
                                            <label for="condLikeNew">Like New</label>
                                        </div>
                                        
                                        <div class="condition-option">
                                            <input type="radio" name="condition" value="GOOD" 
                                                   id="condGood" ${listing.condition == 'GOOD' ? 'checked' : ''}>
                                            <label for="condGood">Good</label>
                                        </div>
                                        
                                        <div class="condition-option">
                                            <input type="radio" name="condition" value="FAIR" 
                                                   id="condFair" ${listing.condition == 'FAIR' ? 'checked' : ''}>
                                            <label for="condFair">Fair</label>
                                        </div>
                                        
                                        <div class="condition-option">
                                            <input type="radio" name="condition" value="OLD" 
                                                   id="condOld" ${listing.condition == 'OLD' ? 'checked' : ''}>
                                            <label for="condOld">Old</label>
                                        </div>
                                    </div>
                                    <small class="text-muted">Current: ${listing.condition} (leave unchecked to keep current)</small>
                                </div>
                                
                                <div class="col-12">
                                    <div class="form-check">
                                        <input type="checkbox" class="form-check-input" name="negotiable" 
                                               id="negotiable" value="true" ${listing.negotiable ? 'checked' : ''}>
                                        <label class="form-check-label" for="negotiable">
                                            Price is negotiable
                                        </label>
                                    </div>
                                    <small class="text-muted">Current: ${listing.negotiable ? 'Negotiable' : 'Fixed price'}</small>
                                </div>
                            </div>
                        </div>

                        <!-- Current Images -->
                        <div class="mb-4">
                            <h5 class="form-section-title">
                                <i class="fas fa-images"></i>Current Images
                            </h5>
                            
                            <div class="current-images" id="currentImages">
                                <c:forEach var="image" items="${existingImages}">
                                    <div class="current-image-item" data-image-id="${image.listingImageId}">
                                        <c:if test="${image.isPrimary}">
                                            <div class="primary-badge">
                                                <i class="fas fa-star"></i> Primary
                                            </div>
                                        </c:if>
                                        <img src="${image.imageUrl}" alt="Product image">
                                        <div class="image-actions">
                                            <c:if test="${!image.isPrimary}">
                                                <a href="${pageContext.request.contextPath}/listings/set-primary-image/${image.listingImageId}" 
                                                   class="btn btn-sm btn-primary">
                                                    <i class="fas fa-star"></i> Make Primary
                                                </a>
                                            </c:if>
                                            <button type="button" class="btn btn-sm btn-danger delete-image-btn" 
                                                    data-image-id="${image.listingImageId}">
                                                <i class="fas fa-trash"></i> Delete
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            
                            <!-- Hidden inputs for images to delete -->
                            <input type="hidden" name="imagesToDelete" id="imagesToDelete" value="">
                        </div>

                        <!-- Add New Images -->
                        <div class="mb-4">
                            <h5 class="form-section-title">
                                <i class="fas fa-plus-circle"></i>Add New Images
                            </h5>
                            
                            <div class="upload-area" id="uploadArea">
                                <i class="fas fa-cloud-upload-alt"></i>
                                <h5>Click to upload new images</h5>
                                <p class="text-muted">You can upload up to 5 images total</p>
                            </div>
                            
                            <input type="file" class="image-input" id="imageInput" 
                                   name="newImages" multiple accept="image/*">
                            
                            <div class="preview-container" id="previewContainer"></div>
                        </div>

                        <!-- Submit Buttons -->
                        <div class="row g-3">
                            <div class="col-md-6">
                                <button type="submit" class="btn-submit w-100">
                                    <i class="fas fa-save me-2"></i>Save Changes
                                </button>
                            </div>
                            <div class="col-md-6">
                                <a href="${pageContext.request.contextPath}/listings/my-listings" 
                                   class="btn-cancel w-100 text-center">
                                    <i class="fas fa-times me-2"></i>Cancel
                                </a>
                            </div>
                        </div>
                        
                        <p class="text-muted text-center mt-3 mb-0">
                            <i class="fas fa-info-circle me-1"></i>
                            Only fields you fill will be updated. Empty fields will keep their current values.
                        </p>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Track initial image count
        let initialImageCount = document.querySelectorAll('.current-image-item:not([style*="display: none"])').length;
        
        // Image deletion handling
        const imagesToDelete = [];
        const imagesToDeleteInput = document.getElementById('imagesToDelete');
        let visibleImagesCount = initialImageCount;
        
        document.querySelectorAll('.delete-image-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const imageId = this.dataset.imageId;
                const imageDiv = document.querySelector(`.current-image-item[data-image-id="${imageId}"]`);
                
                if (confirm('Are you sure you want to delete this image?')) {
                    imagesToDelete.push(imageId);
                    imagesToDeleteInput.value = imagesToDelete.join(',');
                    imageDiv.style.display = 'none';
                    visibleImagesCount--;
                }
            });
        });
        
        // New image upload preview
        const uploadArea = document.getElementById('uploadArea');
        const imageInput = document.getElementById('imageInput');
        const previewContainer = document.getElementById('previewContainer');
        let newFiles = [];
        
        if (uploadArea) {
            uploadArea.addEventListener('click', () => {
                imageInput.click();
            });
            
            uploadArea.addEventListener('dragover', (e) => {
                e.preventDefault();
                uploadArea.style.borderColor = '#667eea';
                uploadArea.style.background = '#f0f2f5';
            });
            
            uploadArea.addEventListener('dragleave', () => {
                uploadArea.style.borderColor = '#dee2e6';
                uploadArea.style.background = '#f8f9fa';
            });
            
            uploadArea.addEventListener('drop', (e) => {
                e.preventDefault();
                uploadArea.style.borderColor = '#dee2e6';
                uploadArea.style.background = '#f8f9fa';
                const files = Array.from(e.dataTransfer.files).filter(file => file.type.match('image.*'));
                addNewFiles(files);
            });
        }
        
        if (imageInput) {
            imageInput.addEventListener('change', (e) => {
                const files = Array.from(e.target.files);
                addNewFiles(files);
            });
        }
        
        function addNewFiles(files) {
            const totalAfterAdd = visibleImagesCount + newFiles.length + files.length;
            if (totalAfterAdd > 5) {
                alert(`Maximum 5 images allowed. Current: ${visibleImagesCount + newFiles.length}`);
                return;
            }
            
            files.forEach(file => {
                if (file.type.match('image.*')) {
                    newFiles.push(file);
                }
            });
            
            renderNewPreviews();
            updateFileInput();
        }
        
        function renderNewPreviews() {
            previewContainer.innerHTML = '';
            newFiles.forEach((file, index) => {
                const reader = new FileReader();
                reader.onload = (e) => {
                    const previewItem = document.createElement('div');
                    previewItem.className = 'preview-item';
                    previewItem.innerHTML = `
                        <img src="${e.target.result}" alt="Preview">
                        <button type="button" class="remove-preview" data-index="${index}">
                            <i class="fas fa-times"></i>
                        </button>
                    `;
                    previewContainer.appendChild(previewItem);
                };
                reader.readAsDataURL(file);
            });
            
            document.querySelectorAll('.remove-preview').forEach(btn => {
                btn.addEventListener('click', function() {
                    const index = parseInt(this.dataset.index);
                    newFiles.splice(index, 1);
                    renderNewPreviews();
                    updateFileInput();
                });
            });
        }
        
        function updateFileInput() {
            const dataTransfer = new DataTransfer();
            newFiles.forEach(file => dataTransfer.items.add(file));
            imageInput.files = dataTransfer.files;
        }
        
        // Category filtering
        const categorySelect = document.getElementById('categorySelect');
        const subCategorySelect = document.getElementById('subCategorySelect');
        
        if (categorySelect && subCategorySelect) {
            const allSubOptions = Array.from(subCategorySelect.options);
            
            categorySelect.addEventListener('change', function() {
                const selectedCategory = this.value;
                
                subCategorySelect.innerHTML = '<option value="">-- Keep Current --</option>';
                
                if (selectedCategory) {
                    allSubOptions.forEach(option => {
                        if (option.value && option.dataset.category == selectedCategory) {
                            subCategorySelect.appendChild(option.cloneNode(true));
                        }
                    });
                } else {
                    allSubOptions.forEach(option => {
                        if (option.value) {
                            subCategorySelect.appendChild(option.cloneNode(true));
                        }
                    });
                }
            });
        }
        
        // Form validation - Only check if at least one image remains after all operations
        document.getElementById('editForm').addEventListener('submit', function(e) {
            const totalImagesAfterUpdate = visibleImagesCount + newFiles.length;
            
            if (totalImagesAfterUpdate === 0) {
                e.preventDefault();
                alert('Your listing must have at least one image! Please keep at least one existing image or upload a new one.');
                return false;
            }
            
            if (totalImagesAfterUpdate > 5) {
                e.preventDefault();
                alert('You cannot have more than 5 images per listing!');
                return false;
            }
            
            return true;
        });
    </script>
</body>
</html>