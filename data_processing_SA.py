import rasterio
import numpy as np
import pandas as pd

# === path ===
base = "/Users/yun-roulin/Desktop/Couses/CEE598/Project_model/training data/test_training"

dem_path   = f"{base}/test_dem_mod.tif"
slope_path = f"{base}/slope_aligned.tif"
dtw_path   = f"{base}/dtw_aligned.tif"
lulc_path  = f"{base}/landuse_aligned.tif"
flood_path = f"{base}/1205_aligned.tif"

# === read raster ===
with rasterio.open(dem_path) as src:
    dem = src.read(1)
    profile = src.profile   # transform
    mask = dem != src.nodata  # 

slope = rasterio.open(slope_path).read(1)
dtw   = rasterio.open(dtw_path).read(1)
lulc  = rasterio.open(lulc_path).read(1)
flood = rasterio.open(flood_path).read(1)

# === raster --> flatten --> 1D array ===
# flatten
dem_flat   = dem.flatten()
slope_flat = slope.flatten()
dtw_flat   = dtw.flatten()
lulc_flat  = lulc.flatten()
flood_flat = flood.flatten()
mask_flat  = mask.flatten()

# Delete NoData
valid = mask_flat & np.isfinite(flood_flat)

dem_f   = dem_flat[valid]
slope_f = slope_flat[valid]
dtw_f   = dtw_flat[valid]
lulc_f  = lulc_flat[valid]
flood_f = flood_flat[valid]

# DataFrame
data = pd.DataFrame({
    "dem": dem_f,
    "slope": slope_f,
    "dist2river": dtw_f,
    "landcover": lulc_f,
    "label": flood_f
})

# remove any remaining NaN rows (if any)
data = data.dropna()

# === save to CSV ===
out_csv = "/Users/yun-roulin/Desktop/Couses/CEE598/Project_model/flood_data.csv"
data.to_csv(out_csv, index=False)

print("Saved:", out_csv)
print("number of samples:", len(data))