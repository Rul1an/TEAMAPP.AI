-- Add missing storage helper functions
-- Date: July 31, 2025
-- Purpose: Fix missing storage.folder function error

-- Create storage.folder function
CREATE OR REPLACE FUNCTION storage.folder(file_path text)
RETURNS text[]
LANGUAGE plpgsql
AS $$
BEGIN
  -- Extract folder path components from file path
  -- Example: "org1/videos/file.mp4" returns {"org1", "videos"}
  IF file_path IS NULL OR file_path = '' THEN
    RETURN '{}';
  END IF;

  -- Split path by '/' and remove the filename (last element)
  RETURN string_to_array(
    regexp_replace(file_path, '/[^/]*$', ''),
    '/'
  );
END;
$$;

-- Also create storage.foldername function (used in some migrations)
CREATE OR REPLACE FUNCTION storage.foldername(file_path text)
RETURNS text[]
LANGUAGE plpgsql
AS $$
BEGIN
  -- Same as storage.folder for compatibility
  RETURN storage.folder(file_path);
END;
$$;

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION storage.folder(text) TO authenticated, service_role;
GRANT EXECUTE ON FUNCTION storage.foldername(text) TO authenticated, service_role;

COMMENT ON FUNCTION storage.folder(text) IS 'Extract folder path components from file path';
COMMENT ON FUNCTION storage.foldername(text) IS 'Alias for storage.folder for backward compatibility';
