/**
 * @file This file implements FileUtils class functionality.
 */
package lottie.utils

/**
 * Get Bundle Name
 *
 * @return Type of String, returns bundle name
 */
func getBundleName(): String {
    let bundleFlags = GET_BUNDLE_INFO_DEFAULT.getValue()
    let bundleInfo = BundleManager.getBundleInfoForSelf(bundleFlags)
    return bundleInfo.name
}

public class FileUtils {
    // Download folder temporary storage address
    public static let downloadBase: String = "file://${getBundleName()}"
    public static let downloadFolder: String = "/data/storage/el2/base/files"
    public static let downloadFolderLottie: String = "/data/storage/el2/base/files/lottie"
    public static let downloadFolderImage: String = "/data/storage/el2/base/files/lottie/loadImages"

    public static let phoneFolder: String = "/data/storage/el2/base/files/entry/"

    public static let SEPARATOR: String = "/"

    public static func fileList(way: String): Array<FileInfo> {
        return Directory.readFrom(way)
    }
    public static func fileAndDirectoryList(way: String): Array<FileInfo> {
        return Directory.readFrom(way)
    }
    public static func directoryList(way: String): Array<FileInfo> {
        return Directory.readFrom(way)
    }


    /**
     * Determine if the path file exists.
     *
     * @Param path - Folder absolute path.
     * @Return Type of Bool, returns true if the path file exists, otherwise returns false.
     */
    public static func accessSync(path: String): Bool {
        return exists(path)
    }

    /**
     * Reading of files with path.
     *
     * @Param path - File absolute path.
     * @Return Type of Array<Byte>, returns data read from a file.
     */
    public static func readToEnd(path: String): Array<Byte> {
        return File.readFrom(path)
    }

    public static func readLenToBuffer(path: String, magic_size: Int64): Array<Byte> {
        let file: File = File(path, OpenMode.Read)
        let buf: Array<Byte> = Array<Byte>(magic_size, repeat:0)
        file.read(buf)
        file.close()
        return buf
    }

    public static func moveDirectory(srcPath: String, destPath: String, overwrite: Bool): Unit {
        copy(srcPath, to: destPath, overwrite: overwrite)
        remove(srcPath, recursive: true)
    }

    public static func moveFile(srcPath: String, destPath: String, overwrite: Bool): Unit {
        copy(srcPath, to: destPath, overwrite: overwrite)
        remove(srcPath, recursive: false)
    }

    public static func deleteDirectory(path: String, recursive!: Bool = false): Unit {
        remove(path, recursive: recursive)
    }

    public static func deleteFile(path: String): Unit {
        remove(path, recursive: false)
    }

    public static func listFileSync(path: String): Array<FileInfo> {
        let files: Array<FileInfo> = Directory.readFrom(path)
        return files
    }


    /**
     * create folder.
     *
     * @Param path - The absolute path of the folder can only be generated for paths within the permission range.
     */
    public static func createFolder(path: String, recursive!: Bool = false): Unit {
        let exists: Bool = exists(path)
        if (recursive) {
            if (!exists) {
                let lastInterval: Int64 = path.lastIndexOf(FileUtils.SEPARATOR) ?? -1
                if (lastInterval <= 0) {
                    return
                }
                Directory.create(path, recursive: recursive)
            }
        } else {
            if (!exists) {
                Directory.create(path)
            }
        }
    }

}
