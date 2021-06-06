import Foundation

final class FillWithColor {
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {

        if (image.first == nil || newColor >= 65536 || row < 0 || column < 0){
            return image
        }
        let columnCount = image[0].count-1;
        let rowCount = image.count-1;
        if(row > rowCount || column > columnCount  || columnCount >= 50 || rowCount >= 50){
            return image
        }
        
        var result = image
        let colorStart = image[row][column]
        var heads = [(row, column)]
        while heads.count > 0 {
            let (row, column) = heads[0]
            heads.remove(at: 0)
            for (r, c) in [(row+1, column), (row-1, column), (row, column+1), (row, column-1)]{
                if(r >= 0 && c >= 0 && r <= rowCount && c <= columnCount && result[r][c] == colorStart){
                    heads.append((r,c))
                }
            }
            result[row][column] = newColor
        }
        return result
    }
    
}
