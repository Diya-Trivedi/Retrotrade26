<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Listing - Retrotrade</title>
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
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
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
            display: flex;
            align-items: center;
        }
        
        .form-section-title i {
            color: #667eea;
            margin-right: 10px;
            font-size: 20px;
        }
        
        .upload-area {
            border: 2px dashed #dee2e6;
            border-radius: 15px;
            padding: 40px;
            text-align: center;
            background: #f8f9fa;
            cursor: pointer;
            transition: all 0.3s;
            margin-bottom: 20px;
        }
        
        .upload-area:hover {
            border-color: #667eea;
            background: #f0f2f5;
        }
        
        .upload-area i {
            font-size: 48px;
            color: #667eea;
            margin-bottom: 15px;
        }
        
        .upload-area h5 {
            color: #495057;
            margin-bottom: 5px;
            font-weight: 600;
        }
        
        .upload-area p {
            color: #6c757d;
            font-size: 14px;
            margin-bottom: 0;
        }
        
        .preview-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 15px;
            margin-top: 20px;
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
        
        .preview-item .remove-btn {
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
            transition: all 0.3s;
            z-index: 10;
        }
        
        .preview-item .remove-btn:hover {
            background: #dc3545;
            transform: scale(1.1);
        }
        
        .preview-item .primary-badge {
            position: absolute;
            bottom: 5px;
            left: 5px;
            background: var(--primary-gradient);
            color: white;
            padding: 2px 8px;
            border-radius: 15px;
            font-size: 10px;
            font-weight: 600;
            z-index: 10;
        }
        
        .image-input {
            display: none;
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
            box-shadow: 0 4px 10px rgba(102, 126, 234, 0.3);
        }
        
        .condition-option label:hover {
            border-color: #667eea;
            background: #f0f2f5;
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
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102,126,234,0.4);
            color: white;
        }
        
        .btn-submit:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
        
        .btn-back {
            background: #6c757d;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .btn-back:hover {
            background: #5a6268;
            transform: translateY(-2px);
            color: white;
        }
        
        .alert {
            border-radius: 10px;
            margin-bottom: 20px;
            border: none;
            padding: 15px 20px;
        }
        
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }
        
        .form-label {
            font-weight: 500;
            color: #495057;
            margin-bottom: 8px;
        }
        
        .form-label .required {
            color: #dc3545;
            margin-left: 3px;
        }
        
        .form-control, .form-select {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 10px 15px;
            transition: all 0.3s;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        textarea.form-control {
            min-height: 100px;
            resize: vertical;
        }
        
        .negotiable-checkbox {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 0;
        }
        
        .negotiable-checkbox input {
            width: 20px;
            height: 20px;
            cursor: pointer;
            accent-color: #667eea;
        }
        
        .negotiable-checkbox label {
            cursor: pointer;
            font-weight: 500;
            color: #495057;
        }
        
        .loading-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255,255,255,0.9);
            z-index: 9999;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            gap: 20px;
        }
        
        .loading-spinner {
            width: 60px;
            height: 60px;
            border: 5px solid #f3f3f3;
            border-top: 5px solid #667eea;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        .loading-text {
            color: #667eea;
            font-size: 18px;
            font-weight: 600;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .info-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }
        
        .info-text i {
            color: #667eea;
            margin-right: 5px;
        }
        
        .field-error {
            border-color: #dc3545 !important;
        }
        
        .error-message {
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
        }
        
        .min-images-warning {
            background-color: #fff3cd;
            border: 1px solid #ffeeba;
            color: #856404;
            padding: 10px 15px;
            border-radius: 8px;
            margin-top: 10px;
            font-size: 14px;
        }
        
        .min-images-warning i {
            color: #856404;
            margin-right: 8px;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner"></div>
        <div class="loading-text">Adding your listing...</div>
    </div>

    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2><i class="fas fa-plus-circle me-2"></i>Add New Listing</h2>
                    <p class="mb-0 opacity-75">List your item for sale on Retrotrade marketplace</p>
                </div>
                <a href="${pageContext.request.contextPath}/listings/my-listings" class="btn-back">
                    <i class="fas fa-arrow-left me-2"></i>Back to My Listings
                </a>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <!-- Error/Success Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/listings/add" method="post" enctype="multipart/form-data" id="listingForm">
                    <div class="form-container">
                        <!-- Basic Information Section -->
                        <div class="mb-4">
                            <h5 class="form-section-title">
                                <i class="fas fa-info-circle"></i>Basic Information
                            </h5>
                            
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">
                                        Product Name <span class="required">*</span>
                                    </label>
                                    <input type="text" class="form-control" name="listingName" id="listingName" required 
                                           placeholder="e.g., iPhone 12, Sony PlayStation 5"
                                           maxlength="100" value="${param.listingName}">
                                    <div class="info-text">
                                        <i class="fas fa-info-circle"></i>Maximum 100 characters
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">Brand</label>
                                    <input type="text" class="form-control" name="brand" 
                                           placeholder="e.g., Apple, Sony, Samsung"
                                           maxlength="50" value="${param.brand}">
                                </div>
                                
                                <div class="col-12">
                                    <label class="form-label">
                                        Description <span class="required">*</span>
                                    </label>
                                    <textarea class="form-control" name="description" id="description" required 
                                              placeholder="Describe your product in detail - condition, features, reason for selling, etc."
                                              maxlength="1000">${param.description}</textarea>
                                    <div class="info-text">
                                        <i class="fas fa-info-circle"></i>Maximum 1000 characters
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Category Section - Both dropdowns are static -->
                        <div class="mb-4">
                            <h5 class="form-section-title">
                                <i class="fas fa-tags"></i>Category
                            </h5>
                            
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">
                                        Category <span class="required">*</span>
                                    </label>
                                    <select class="form-select" name="categoryId" id="categorySelect" required>
                                        <option value="">Select Category</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.categoryId}" ${param.categoryId == cat.categoryId ? 'selected' : ''}>${cat.categoryName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">
                                        Subcategory <span class="required">*</span>
                                    </label>
                                    <select class="form-select" name="subCategoryId" id="subCategorySelect" required>
                                        <option value="">Select Subcategory</option>
                                        <c:forEach var="subCat" items="${subcategories}">
                                            <option value="${subCat.subCategoryId}" ${param.subCategoryId == subCat.subCategoryId ? 'selected' : ''}>
                                                ${subCat.subCategoryName} (${subCat.category.categoryName})
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div class="info-text mt-1">
                                        <i class="fas fa-info-circle"></i> Select from all available subcategories
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Price & Condition Section -->
                        <div class="mb-4">
                            <h5 class="form-section-title">
                                <i class="fas fa-rupee-sign"></i>Price & Condition
                            </h5>
                            
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">
                                        Price (₹) <span class="required">*</span>
                                    </label>
                                    <input type="number" class="form-control" name="price" id="price" required 
                                           step="0.01" min="0" placeholder="e.g., 15000" value="${param.price}"
                                           oninput="this.value = this.value.replace(/[^0-9.]/g, '')">
                                    <div class="info-text">
                                        <i class="fas fa-info-circle"></i>Enter in Indian Rupees
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">
                                        Location <span class="required">*</span>
                                    </label>
                                    <input type="text" class="form-control" name="location" id="location" required 
                                           placeholder="e.g., Mumbai, Delhi, Bangalore" value="${param.location}"
                                           maxlength="100">
                                    <div class="info-text">
                                        <i class="fas fa-info-circle"></i>Maximum 100 characters
                                    </div>
                                </div>
                                
                                <div class="col-12">
                                    <label class="form-label">
                                        Condition <span class="required">*</span>
                                    </label>
                                    <div class="condition-container">
                                        <div class="condition-option">
                                            <input type="radio" name="condition" value="NEW" id="condNew" ${param.condition == 'NEW' ? 'checked' : ''} required>
                                            <label for="condNew">New</label>
                                        </div>
                                        
                                        <div class="condition-option">
                                            <input type="radio" name="condition" value="LIKE_NEW" id="condLikeNew" ${param.condition == 'LIKE_NEW' ? 'checked' : ''}>
                                            <label for="condLikeNew">Like New</label>
                                        </div>
                                        
                                        <div class="condition-option">
                                            <input type="radio" name="condition" value="GOOD" id="condGood" ${param.condition == 'GOOD' ? 'checked' : ''}>
                                            <label for="condGood">Good</label>
                                        </div>
                                        
                                        <div class="condition-option">
                                            <input type="radio" name="condition" value="FAIR" id="condFair" ${param.condition == 'FAIR' ? 'checked' : ''}>
                                            <label for="condFair">Fair</label>
                                        </div>
                                        
                                        <div class="condition-option">
                                            <input type="radio" name="condition" value="OLD" id="condOld" ${param.condition == 'OLD' ? 'checked' : ''}>
                                            <label for="condOld">Old</label>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-12">
                                    <div class="negotiable-checkbox">
                                        <input type="checkbox" name="negotiable" id="negotiable" value="true" ${param.negotiable == 'true' ? 'checked' : ''}>
                                        <label for="negotiable">Price is negotiable</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Images Upload Section - MODIFIED to accept any image types and any size -->
                        <div class="mb-4">
                            <h5 class="form-section-title">
                                <i class="fas fa-images"></i>Product Images
                                <span class="required ms-1">*</span>
                                <small class="text-muted ms-2">(Upload at least 5 images, first image will be primary)</small>
                            </h5>
                            
                            <div class="upload-area" id="uploadArea">
                                <i class="fas fa-cloud-upload-alt"></i>
                                <h5>Click to upload or drag and drop</h5>
                                <p class="text-muted">Any image type allowed (PNG, JPG, JPEG, GIF, BMP, WEBP, etc.)</p>
                                <p class="text-muted small mt-2">
                                    <i class="fas fa-info-circle"></i> 
                                    You can select multiple images at once - Minimum 5 images required
                                </p>
                            </div>
                            
                            <input type="file" class="image-input" id="imageInput" 
                                   name="images" multiple accept="image/*" required>
                            
                            <div class="preview-container" id="previewContainer"></div>
                            
                            <!-- Warning message for minimum images requirement -->
                            <div class="min-images-warning" id="minImagesWarning" style="display: none;">
                                <i class="fas fa-exclamation-triangle"></i>
                                <span id="warningMessage">Please upload at least 5 images. Currently selected: <span id="currentCount">0</span></span>
                            </div>
                            
                            <div class="info-text mt-2" id="imageCountInfo">
                                <i class="fas fa-images me-1"></i>
                                <span id="selectedCount">0</span> images selected (minimum 5 required)
                            </div>
                        </div>

                        <!-- Submit Buttons -->
                        <div class="row g-3">
                            <div class="col-md-8">
                                <button type="submit" class="btn-submit" id="submitBtn">
                                    <i class="fas fa-plus-circle"></i>
                                    Add Listing
                                </button>
                            </div>
                            <div class="col-md-4">
                                <a href="${pageContext.request.contextPath}/listings/my-listings" class="btn-back w-100">
                                    <i class="fas fa-times-circle"></i>
                                    Cancel
                                </a>
                            </div>
                        </div>
                        
                        <p class="text-muted text-center mt-3 mb-0">
                            <i class="fas fa-info-circle me-1"></i>
                            Your listing will be reviewed by admin before going live
                        </p>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Image Upload Preview - MODIFIED to accept any image types and any size
        const uploadArea = document.getElementById('uploadArea');
        const imageInput = document.getElementById('imageInput');
        const previewContainer = document.getElementById('previewContainer');
        const loadingOverlay = document.getElementById('loadingOverlay');
        const submitBtn = document.getElementById('submitBtn');
        const selectedCountSpan = document.getElementById('selectedCount');
        const minImagesWarning = document.getElementById('minImagesWarning');
        const warningMessage = document.getElementById('warningMessage');
        const currentCountSpan = document.getElementById('currentCount');
        
        let selectedFiles = [];
        const MIN_IMAGES_REQUIRED = 1;

        // Click upload area
        uploadArea.addEventListener('click', () => {
            imageInput.click();
        });

        // Drag and drop events
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
            
            const files = Array.from(e.dataTransfer.files).filter(file => 
                file.type.match('image.*') // Keep only image files, but any image type is accepted
            );
            
            addFiles(files);
        });

        // File input change - MODIFIED: removed size and type restrictions
        imageInput.addEventListener('change', (e) => {
            const files = Array.from(e.target.files);
            addFiles(files);
        });

        function addFiles(files) {
            // No file count limit anymore - can add any number of files
            const validFiles = files.filter(file => {
                // Only filter by file type to ensure it's an image
                if (!file.type.match('image.*')) {
                    alert(`File "${file.name}" is not an image file. Please upload only image files.`);
                    return false;
                }
                return true;
            });
            
            validFiles.forEach(file => {
                selectedFiles.push(file);
                
                const reader = new FileReader();
                reader.onload = (e) => {
                    createPreviewItem(file, e.target.result);
                };
                reader.readAsDataURL(file);
            });
            
            updateFileInput();
            updateImageCount();
            checkMinimumImages();
        }

        function createPreviewItem(file, imageUrl) {
            const previewItem = document.createElement('div');
            previewItem.className = 'preview-item';
            
            const img = document.createElement('img');
            img.src = imageUrl;
            
            const removeBtn = document.createElement('button');
            removeBtn.className = 'remove-btn';
            removeBtn.innerHTML = '<i class="fas fa-times"></i>';
            removeBtn.onclick = (e) => {
                e.stopPropagation();
                removeFile(file);
            };
            
            previewItem.appendChild(img);
            previewItem.appendChild(removeBtn);
            
            if (selectedFiles.indexOf(file) === 0) {
                const primaryBadge = document.createElement('span');
                primaryBadge.className = 'primary-badge';
                primaryBadge.textContent = 'Primary';
                previewItem.appendChild(primaryBadge);
            }
            
            previewContainer.appendChild(previewItem);
        }

        function removeFile(fileToRemove) {
            selectedFiles = selectedFiles.filter(file => file !== fileToRemove);
            renderPreviews();
            updateFileInput();
            updateImageCount();
            checkMinimumImages();
        }

        function renderPreviews() {
            previewContainer.innerHTML = '';
            selectedFiles.forEach((file, index) => {
                const reader = new FileReader();
                reader.onload = (e) => {
                    createPreviewItem(file, e.target.result);
                };
                reader.readAsDataURL(file);
            });
        }

        function updateFileInput() {
            const dataTransfer = new DataTransfer();
            selectedFiles.forEach(file => dataTransfer.items.add(file));
            imageInput.files = dataTransfer.files;
        }
        
        function updateImageCount() {
            const count = selectedFiles.length;
            selectedCountSpan.textContent = count;
            if (currentCountSpan) {
                currentCountSpan.textContent = count;
            }
            
            // Update required attribute based on minimum images
            if (count >= MIN_IMAGES_REQUIRED) {
                imageInput.required = false;
            } else {
                imageInput.required = true;
            }
        }
        
        function checkMinimumImages() {
            const count = selectedFiles.length;
            if (count < MIN_IMAGES_REQUIRED) {
                minImagesWarning.style.display = 'block';
                warningMessage.innerHTML = `Please upload at least ${MIN_IMAGES_REQUIRED} images. Currently selected: ${count}`;
            } else {
                minImagesWarning.style.display = 'none';
            }
        }

        // Form validation - MODIFIED to check for minimum 5 images
        document.getElementById('listingForm').addEventListener('submit', function(e) {
            let hasError = false;
            
            // Clear previous errors
            document.querySelectorAll('.field-error').forEach(el => {
                el.classList.remove('field-error');
            });
            document.querySelectorAll('.error-message').forEach(el => {
                el.remove();
            });
            
            // Check product name
            const listingName = document.getElementById('listingName');
            if (!listingName.value.trim()) {
                highlightError(listingName, 'Product name is required');
                hasError = true;
            }
            
            // Check description
            const description = document.getElementById('description');
            if (!description.value.trim()) {
                highlightError(description, 'Description is required');
                hasError = true;
            }
            
            // Check category
            const categorySelect = document.getElementById('categorySelect');
            if (!categorySelect.value) {
                highlightError(categorySelect, 'Please select a category');
                hasError = true;
            }
            
            // Check subcategory
            const subCategorySelect = document.getElementById('subCategorySelect');
            if (!subCategorySelect.value) {
                highlightError(subCategorySelect, 'Please select a subcategory');
                hasError = true;
            }
            
            // Check price
            const price = document.getElementById('price');
            if (!price.value || parseFloat(price.value) <= 0) {
                highlightError(price, 'Please enter a valid price');
                hasError = true;
            }
            
            // Check location
            const location = document.getElementById('location');
            if (!location.value.trim()) {
                highlightError(location, 'Location is required');
                hasError = true;
            }
            
            // Check condition
            const conditionSelected = document.querySelector('input[name="condition"]:checked');
            if (!conditionSelected) {
                const conditionContainer = document.querySelector('.condition-container');
                const errorDiv = document.createElement('div');
                errorDiv.className = 'error-message';
                errorDiv.textContent = 'Please select a condition';
                conditionContainer.parentNode.appendChild(errorDiv);
                hasError = true;
            }
            
            // Check images - MODIFIED: now checking for minimum 5 images
            if (selectedFiles.length < MIN_IMAGES_REQUIRED) {
                const uploadArea = document.getElementById('uploadArea');
                uploadArea.style.borderColor = '#dc3545';
                const errorDiv = document.createElement('div');
                errorDiv.className = 'error-message';
                errorDiv.textContent = `Please upload at least ${MIN_IMAGES_REQUIRED} images. Currently selected: ${selectedFiles.length}`;
                uploadArea.parentNode.appendChild(errorDiv);
                hasError = true;
                
                // Show warning
                minImagesWarning.style.display = 'block';
                minImagesWarning.style.backgroundColor = '#f8d7da';
                minImagesWarning.style.borderColor = '#f5c6cb';
                minImagesWarning.style.color = '#721c24';
                
                // Reset border after 5 seconds
                setTimeout(() => {
                    uploadArea.style.borderColor = '#dee2e6';
                    minImagesWarning.style.backgroundColor = '#fff3cd';
                    minImagesWarning.style.borderColor = '#ffeeba';
                    minImagesWarning.style.color = '#856404';
                }, 5000);
            }
            
            if (hasError) {
                e.preventDefault();
                alert('Please fill all required fields correctly and upload at least 5 images');
            } else {
                // Show loading overlay
                loadingOverlay.style.display = 'flex';
                submitBtn.disabled = true;
            }
        });

        function highlightError(element, message) {
            element.classList.add('field-error');
            
            // Add error message
            const errorDiv = document.createElement('div');
            errorDiv.className = 'error-message';
            errorDiv.textContent = message;
            element.parentNode.appendChild(errorDiv);
            
            // Remove error after 3 seconds
            setTimeout(() => {
                element.classList.remove('field-error');
                if (errorDiv.parentNode) {
                    errorDiv.remove();
                }
            }, 3000);
        }

        // Price input validation
        document.querySelector('input[name="price"]').addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9.]/g, '');
        });

        // Initialize image count
        updateImageCount();
    </script>
</body>
</html>